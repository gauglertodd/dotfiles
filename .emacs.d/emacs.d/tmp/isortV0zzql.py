# Copyright 2004-present Facebook. All Rights Reserved.

from dataclasses import (
    dataclass,
    field,
)
from eau.harms_portal.harms_portal_common import (
    JoinType,
    LabelTable,
    Metric,
    Signal,
    SignalType,
    SurfaceTable,
)
from eau.harms_portal.harms_portal_query import HarmsPortalQuery
from eau.harms_portal.join_info import JoinInfo
from eau.harms_portal.label_tables_utils import get_label_table_query
from eau.harms_portal.signals import HarmsPortalSignal
from eau.harms_portal.staging_tables_utils import (
    get_combined_staging_table_queries,
    get_signal_metadata_columns,
    get_staging_table_query,
)
from eau.harms_portal.surface_tables_utils import get_surface_table_query
import itertools
from typing import (
    Dict,
    List,
)


def dedupe(l1: List[str], l2: List[str]):
    return list(set(itertools.chain(l1, l2)))


@dataclass
class HarmsPortalMetricSpecifier(object):
    signal: Signal
    surfaces: List[SurfaceTable]
    metrics: List[Metric]


class HarmsPortalQueryBuilder(object):
    label_tables: Dict[LabelTable, HarmsPortalQuery]
    surface_tables: Dict[SurfaceTable, HarmsPortalQuery]
    staging_tables: Dict[HarmsPortalSignal, List[HarmsPortalQuery]]
    metrics: Dict[HarmsPortalSignal, List[HarmsPortalQuery]]
    combined_signals_metrics: List[HarmsPortalQuery]

    def __init__(self, signals: List[HarmsPortalSignal], metrics: List[Metric]):
        all_surfaces = {signal.surface for signal in signals}
        self.surface_tables = {
            table: get_surface_table_query(table) for table in all_surfaces
        }
        all_label_tables = {
            self.get_associated_label_table(surface) for surface in all_surfaces
        }
        self.label_tables = {
            label_table: get_label_table_query(label_table)
            for label_table in all_label_tables
        }

        self.staging_tables = {}
        for signal in signals:
            self.staging_tables.update(get_staging_table_query(signal))

        self.metrics = {
            signal: self.get_metric_queries(metrics, signal) for signal in signals
        }
        self.combined_signals_metrics = self.get_combined_signals_metrics(metrics)

    def get_associated_label_table(self, surface: SurfaceTable) -> LabelTable:
        if surface in {
            SurfaceTable.SEVERITY_WEIGHTED_PREVALENCE_GROUPS,
            SurfaceTable.SEVERITY_WEIGHTED_PREVALENCE_PAGES,
            SurfaceTable.SEVERITY_WEIGHTED_PREVALENCE_USERS,
        }:
            return LabelTable.DIM_IMP_LABELS_SEVERITY_WEIGHTED_PREVALENCE
        raise Exception(f"Unsupported surface: {surface.value}")

    def get_surfaces_query(self, surface: SurfaceTable) -> str:
        label = self.get_associated_label_table(surface)
        label_query = get_label_table_query(label)
        surface_query = get_surface_table_query(surface)
        return (label_query + surface_query).get_string()

    def get_harms_portal_query(self) -> str:
        return (
            " WITH "
            + ",".join(
                itertools.chain(
                    self.get_metrics_metadata_query(),
                    self.get_surfaces_alias_query(),
                    self.get_staging_tables_queries(),
                    [
                        f""" {'_'.join((query+new_query).identifiers)}_alias AS
                              ({(query + new_query).get_string(include_group_by=False)})"""
                        for signal, queries in self.staging_tables.items()
                        for new_signal, new_queries in self.staging_tables.items()
                        for query in queries
                        for new_query in new_queries
                        if signal != new_signal
                    ],
                )
            )
            + "SELECT * FROM "
            + " UNION ALL ".join(
                " ( " + query.get_string() + " ) "
                for query in itertools.chain(
                    [query for queries in self.metrics.values() for query in queries],
                    self.combined_signals_metrics,
                )
            )
        )

    def get_surfaces_alias_query(self) -> List[str]:
        return [
            f" {alias.value}_alias AS ("
            + HarmsPortalQuery(
                tablename=alias.value,
                select_columns=["*"],
                filters=[f"ds = '<LATEST_DS:{alias.value}>'"],
                join_clause=[
                    JoinInfo(
                        source_table=f"{alias.value}_alias",
                        source_keys=[],
                        target_table=f"{alias.value}_metadata",
                        target_keys=[],
                        join_type=JoinType.LEFT_OUTER,
                        new_columns=["*"],
                        filters_on_target_table=[],
                        raw_join_conditions=["True"],
                    ),
                ],
            ).get_string()
            + ")"
            for alias, query in self.surface_tables.items()
        ]

    def get_staging_tables_queries(self) -> List[str]:
        return [
            f" {'_'.join(query.identifiers)}_alias AS ({query.get_string(include_group_by=False)})"
            for alias, queries in self.staging_tables.items()
            for query in queries
        ]

    def get_combined_signals_staging_tables_queries(self) -> List[str]:
        return [
                f""" {'_'.join((query+new_query).identifiers)}_alias AS
                              ({(query + new_query).get_string(include_group_by=False)})"""
                for signal, queries in self.staging_tables.items()
                for new_signal, new_queries in self.staging_tables.items()
                for query in queries
                for new_query in new_queries
                if signal != new_signal
            ]p



    def get_metrics_metadata_query(self) -> List[str]:
        return [
            f"{alias.value}_metadata AS ("
            + HarmsPortalQuery(
                tablename=alias.value,
                select_columns=[],
                raw_columns=get_signal_metadata_columns(self.metrics),
                filters=[f"ds = '<LATEST_DS:{alias.value}>'"],
            ).get_string()
            + " LIMIT 1)"
            for alias, query in self.surface_tables.items()
        ]

    def get_metric(self, metric: Metric) -> str:
        if metric == Metric.SWOP:
            return """
            SUM(label_multiplier * CAST(is_violating AS int) * volume) / SUM(volume)
            """
        if metric == Metric.PERCENTAGE_SWOP:
            return """
            100 * (SUM(label_multiplier * CAST(is_violating AS int) * volume) / (ARBITRARY(total_swop) * ARBITRARY(total_volume)))
            """
        elif metric == Metric.PERCENTAGE_VPV:
            return """
            100 * SUM(volume) / ARBITRARY(total_volume)
            """
        elif metric == Metric.PERCENTAGE_VIOLATING_VPV:
            return """
            100 * SUM(volume * CAST(is_violating AS int)) / SUM(volume)
            """
        elif metric == Metric.TOTAL_VOLUME:
            return """
            SUM(volume)
            """
        elif metric == Metric.PERCENTAGE_VIOLATING_VPV_OVERALL:
            return """
            100 * SUM(volume * CAST(is_violating AS int)) / ARBITRARY(total_violating_volume)
            """
        elif metric == Metric.PERCENTILE_LOWER_BOUND:
            return "ARBITRARY(percentile_lower_bound)"
        elif metric == Metric.PERCENTILE_UPPPER_BOUND:
            return "ARBITRARY(percentile_upper_bound)"

        raise Exception(f"Unsupported Metric type: {metric.value}")

    def get_identifier(self, signal, query):
        signal_type = f"'{'&'.join(query.identifiers)}'"
        if signal.signal_type == SignalType.CATEGORICAL:
            for group_column in query.group_clauses:
                signal_type += f" ||'_'|| COALESCE({group_column}, 'MISSING_VALUE')"
        return signal_type

    def get_metric_queries(self, metrics, signal) -> List[HarmsPortalQuery]:
        raw_metrics = ",".join(
            f"{self.get_metric(metric)} AS {metric.value}" for metric in metrics
        )

        return [
            HarmsPortalQuery(
                tablename="_".join(query.identifiers) + "_alias",
                group_clauses=query.group_clauses,
                select_columns=[],
                raw_columns=[
                    raw_metrics,
                    f"{self.get_identifier(signal, query)} AS signal_type",
                ],
                identifiers=[signal.signal.value],
            )
            for query in self.staging_tables[signal]
        ]

    def get_combined_signals_metrics(self, metrics):
        queries = []
        raw_metrics = ",".join(
            f"{self.get_metric(metric)} AS {metric.value}" for metric in metrics
        )

        combined_signals = [
            (signal, new_signal, query, new_query)
            for signal, queries in self.metrics.items()
            for new_signal, new_queries in self.metrics.items()
            for query in queries
            for new_query in new_queries
            if signal != new_signal
        ]

        return [
            HarmsPortalQuery(
                tablename="_".join((query + new_query).identifiers) + "_alias",
                group_clauses=query.group_clauses + new_query.group_clauses,
                select_columns=[],
                raw_columns=[
                    raw_metrics,
                    f"{'&'.join([self.get_identifier(signal, query), self.get_identifier(new_signal, new_query)])} AS signal_type",
                ],
            )
            for signal, new_signal, query, new_query in combined_signals
        ]
