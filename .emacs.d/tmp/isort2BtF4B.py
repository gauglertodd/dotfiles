#!/usr/bin/env python3
# pyre-strict
# pyre-ignore-all-errors[56]
# pyre-ignore-all-errors[16]
# pyre-ignore-all-errors[6]

from typing import Dict, List, Optional

import fblearner.flow.projects.fluent2.api as f2
from configerator.configerator_config import ConfigeratorConfig
from configerator.structs.eau.modeling.models.types import EauModel
from fblearner.flow.external_api import WorkflowRun
from fblearner.flow.projects.fluent2.definition.storage_config import ManifoldConfig
from fblearner.flow.projects.fluent2.feature_groups.integrity.entity_actor_understanding.eau_config_features import (
    get_context,
    get_root_transformer_factory,
)
from fblearner.flow.projects.fluent2.feature_groups.integrity.entity_actor_understanding.model_keepers.eau_model_keeper_interface import (
    EauModelKeeperInterface,
)


class ParametrizedDomain(Dict[str, str]):
    """Parameterized fluent2 domain for config-specified modeling"""

    def __init__(
        self,
        model_location: str,
        labeled_examples_table_name: str,
        candidates_table_name: Optional[str] = None,
    ) -> None:
        self.model_location = model_location
        self.labeled_examples_table_name: str = labeled_examples_table_name
        self.candidates_tablename: Optional[str] = candidates_table_name
        self.model: EauModel = ConfigeratorConfig(self.model_location, EauModel).get()
        self.model_is_pretrained: bool = self.model.trainer_workflow_id is not None
        self.root_transformer_factory: EauModelKeeperInterface = (
            get_root_transformer_factory(self.model)
        )
        self.context_columns: List[str] = ["ds", "unique_id"]
        self.context: f2.Context = get_context(self.model, self.context_columns)
        self.features: List[f2.Feature] = []
        self.domain_builder: f2.DomainBuilder = (
            f2.DomainBuilder(
                team="fbai_eau_eng",
                name=self.model.name,
                owner=f2.Owner(self.model.pipeline_owner, oncall=self.model.oncall),
                namespace=self.model.eau_namespace.name.lower(),
                model_type="eau_config_based_f2_models",
            )
            .set_run_purposes(f2.RunPurposes(list(self.model.run_purposes)))
            .override_training(
                training=self.root_transformer_factory.get_training_transformer(
                    self.model
                )
            )
        )

        if self.model_is_pretrained:
            self.domain_builder.labels_and_features_from_table(
                hive_namespace=self.model.eau_namespace.name.lower(),
                examples_table=self.candidates_tablename,
                label_hql="TRUE",
                partitions={},
                context_columns=self.context_columns,
                set_name_hql="'OFFLINE_EVAL'",
                candidates_table=self.candidates_tablename,
            )
            self.domain_builder.override_training(
                f2.ExternalTraining(
                    schedule="@daily",
                    examples_fetchers=[],
                    transformer_name_to_model_file_path=WorkflowRun(
                        int(self.model.trainer_workflow_id)
                    )
                    .get_results()
                    .transformer_name_to_model_file_path,
                )
            )
            self.overrideOfflinePredicting()
        else:
            self.domain_builder.labels_and_features_from_table(
                hive_namespace=self.model.eau_namespace.name.lower(),
                examples_table=self.labeled_examples_table_name,
                label_hql=self.model.label_hql or "CAST(label AS int) = 1",
                partitions=self.model.wait_for_partitions or {},
                context_columns=self.context_columns,
                set_name_hql="set_name",
            )

        self.setRootTransformer()
        self.overrideStorageConfig()

    def overrideStorageConfig(self) -> None:
        self.domain_builder._storage_config = ManifoldConfig(
            bucket="eau_fluent2_model_long_retention"
        )

    def overrideOfflinePredicting(self) -> None:
        if self.domain_builder._offline_predicting:
            old_offline_predicting = self.domain_builder._offline_predicting
            self.domain_builder.override_offline_predicting(
                f2.OfflinePredicting(
                    schedule="@daily",
                    candidates_fetcher=old_offline_predicting.candidates_fetcher,
                    publishers=[
                        f2.SimpleHivePublisher(
                            table=f"gauglertodd_domain_builder_{self.model.name}",
                            partition={"partition_ds": "<DATEID>"},
                            oncall=self.model.oncall,
                        )
                    ],
                    use_backfilled_features=True,
                )
            )

    def setRootTransformer(self) -> None:
        self.domain_builder.set_root_transformer(
            self.root_transformer_factory.get_fluent2_transformer(
                self.model,
                self.root_transformer_factory.get_processed_features(
                    self.model,
                    self.domain_builder._features,
                ),
            )
        )
        self.domain_builder._features = (
            self.root_transformer_factory.get_processed_features(
                self.model,
                self.domain_builder._features,
            )
        )

    def getDomain(self) -> f2.Domain:
        return self.domain_builder.get_domain()
