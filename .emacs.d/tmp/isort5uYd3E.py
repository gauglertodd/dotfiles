#!/usr/bin/env python3
# pyre-strict

from dataclasses import dataclass
from typing import cast, Dict, List

import dper3.modules as modules
import fblearner.flow.projects.fluent2.api as f2
from caffe2.python.fb.dper.layer_models.model_definition.ttypes import (
    AdagradDefinition,
    OptimizerDefinition,
)
from dper3.core.module import Module
from dper3.fb.preprocessing.transforms.sparse_feature_normalization import (
    SparseFeatureNormalizationInput,
)
from dper3.modules.architectures.sparse_nn_arch import SparseNNArch
from fblearner.flow.projects.fluent2.definition.feature import Feature
from fblearner.flow.projects.fluent2.definition.sweeping import SEARCH_SPACE_TYPE
from fblearner.flow.projects.fluent2.definition.task_type import TaskType
from fblearner.flow.projects.fluent2.definition.transformers.dper3.preprocessing import (
    MetadataOptions,
)
from fblearner.flow.projects.fluent2.definition.transformers.dper3.sparsenn_model_keeper import (
    Fluent2SparseNNModelKeeper,
)
from fblearner.flow.projects.fluent2.feature_groups.integrity.entity_actor_understanding.model_keepers.eau_model_keeper_interface import (
    EauModelKeeperInterface,
)


class UserCertSparseNNClassifierModelKeeper(
    Fluent2SparseNNModelKeeper, EauModelKeeperInterface
):
    VERSION = 4

    @dataclass()
    class SparseNnHyperparameters:
        dense_arch_width_factor: float
        dense_arch_dropout_ratio: float
        over_arch_width_factor: float
        over_arch_dropout_ratio: float
        dense_alpha: float
        dense_epsilon: float
        epoch: int

    def __init__(
        self,
        features: List[f2.Feature],
        provided_normalization_configs: List[SparseFeatureNormalizationInput],
        task_type: TaskType,
        loss_module: Module,
        params: SparseNnHyperparameters,
    ) -> None:

        super().__init__(features, provided_normalization_configs, task_type)
        self.task_type = f2.ExclusiveTwoClassPredictionTaskType()
        self.loss_module = modules.CrossEntropyLossWithLogit()
        self.params = params

    @classmethod
    def get_sweep_search_space(cls) -> Dict[str, SEARCH_SPACE_TYPE]:
        search_space = cast(
            Dict[str, SEARCH_SPACE_TYPE],
            {
                "dense_arch_width_factor": (0.25, 4.0, True),
                "dense_arch_dropout_ratio": (0.01, 0.5, True),
                "over_arch_width_factor": (0.25, 4.0, True),
                "over_arch_dropout_ratio": (0.01, 1.0, True),
                "epoch": (1, 50, True),
                "dense_alpha": (0.001, 0.1, True),
                "dense_epsilon": (0.001, 0.1, True),
            },
        )
        return search_space

    # pyre-ignore Typing error in DPER3
    def _get_loss_module(self) -> Module:
        return self.loss_module

    # pyre-ignore Typing error in DPER3
    def _get_calibration_module(self) -> Module:
        return modules.calibration.NoneCalibration()

    # pyre-fixme[15]: `_get_sparse_nn_arch` overrides method defined in
    #  `SparseNNModelKeeper` inconsistently.
    def _get_sparse_nn_arch(self) -> Module:
        dense_arch_width_factor = self.params.dense_arch_width_factor
        dense_arch_dropout_ratio = self.params.dense_arch_dropout_ratio
        over_arch_width_factor = self.params.over_arch_width_factor
        over_arch_dropout_ratio = self.params.over_arch_dropout_ratio

        dense_arch = modules.Sequential(
            modules.Linear(output_dims=int(512 * dense_arch_width_factor)),
            modules.Relu(),
            modules.Dropout(ratio=dense_arch_dropout_ratio),
            modules.Linear(output_dims=int(256 * dense_arch_width_factor)),
            modules.Relu(),
            modules.Dropout(ratio=dense_arch_dropout_ratio),
            modules.Linear(output_dims=int(128 * dense_arch_width_factor)),
            modules.Relu(),
            modules.Dropout(ratio=dense_arch_dropout_ratio),
            modules.Linear(output_dims=int(128 * dense_arch_width_factor)),
            modules.Relu(),
            modules.Dropout(ratio=dense_arch_dropout_ratio),
        )

        over_arch = modules.Sequential(
            modules.Linear(output_dims=int(128 * over_arch_width_factor)),
            modules.Relu(),
            modules.Dropout(ratio=over_arch_dropout_ratio),
            modules.Linear(output_dims=int(64 * over_arch_width_factor)),
            modules.Relu(),
            modules.Dropout(ratio=over_arch_dropout_ratio),
            modules.Linear(output_dims=1),
        )

        return SparseNNArch(
            dense_arch=dense_arch,
            over_arch=over_arch,
        )

    def get_task_type(self):
        return f2.ExclusiveTwoClassPredictionTaskType()

    # pyre-fixme[3]: Return type must be annotated.
    def get_distributed_training_options(self):
        dt_options = super().get_distributed_training_options()
        dt_options.reader.reader_options.num_passes = self.params.epoch
        return dt_options

    def get_optimizers(self) -> Dict[str, OptimizerDefinition]:
        dense_alpha = self.params.dense_alpha
        dense_epsilon = self.params.dense_epsilon

        return {
            "default": OptimizerDefinition(
                adagrad=AdagradDefinition(
                    alpha=dense_alpha,
                    epsilon=dense_epsilon,
                )
            ),
        }

    def int_single_categorical_to_multi_transformer(
        self,
        features: List[f2.IntSingleCategoricalFeature],
    ) -> List[Feature]:
        return list(
            f2.CategoricalSingleToMultiTransformer(
                name="int_single_categorical_to_multi", features=features
            ).get_output_features()
        )

    @staticmethod
    def get_processed_features(features: List[f2.Feature]) -> List[Feature]:
        int_single_categorical_features = [
            feature
            for feature in features
            if isinstance(feature, f2.IntSingleCategoricalFeature)
        ]
        transformed_features = [
            feature
            for feature in features
            if feature not in int_single_categorical_features
        ]
        transformed_features += list(
            f2.CategoricalSingleToMultiTransformer(
                name="int_single_categorical_to_multi",
                features=int_single_categorical_features,
            ).get_output_features()
        )
        return transformed_features

    @staticmethod
    def get_fluent2_transformer(features: List[f2.Feature]) -> f2.DPer3MTMLTransformer:
        return f2.DPer3Transformer(
            name="user_cert_sparse_nn_classification_model",
            features=UserCertSparseNNClassifierModelKeeper.get_processed_features(
                features
            ),
            model_keeper_class=UserCertSparseNNClassifierModelKeeper,
            model_keeper_kwargs={
                "loss_module": modules.CrossEntropyLossWithLogit(),
                "params": UserCertSparseNNClassifierModelKeeper.SparseNnHyperparameters(
                    dense_arch_width_factor=1.0,
                    dense_arch_dropout_ratio=0.05,
                    over_arch_width_factor=1.0,
                    over_arch_dropout_ratio=0.05,
                    dense_alpha=0.005,
                    dense_epsilon=0.01,
                    epoch=30,
                ),
            },
            training_sets_filter=f2.PatternFilter("%training"),
            validation_sets_filter=f2.PatternFilter("%validation"),
            task_type=f2.ExclusiveTwoClassPredictionTaskType(),
            metadata_options=MetadataOptions(
                inline_metadata_run=False,
                shuffle_splits=True,
                num_examples=10000000,
            ),
        )
