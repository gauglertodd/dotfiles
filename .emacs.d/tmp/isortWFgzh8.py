# Copyright 2004-present Facebook. All Rights Reserved.

from typing import (
    Dict,
    List,
)

from eau.harms_portal.harms_portal_common import (
    Signal,
    SignalType,
    SurfaceTable,
)
from eau.harms_portal.harms_portal_query import (
    HarmsPortalQuery,
)
from eau.harms_portal.metric_utils import get_all_metric_columns
from eau.harms_portal.signals import HarmsPortalSignal


def get_signal_metadata_columns(
    metrics: Dict[HarmsPortalSignal, List[HarmsPortalQuery]]
) -> List[str]:
    columns = []
    signals = {
        signal
        for signal in metrics.keys()
        if signal.signal_type == SignalType.CONTINUOUS
    }
    for signal in signals:
        for i in range(10, 100, 10):
            col = signal.column
            percentile = i / 100.0
            alias = f"{signal.signal.value}_p{i}"
            columns.append(f"APPROX_PERCENTILE({col}, {percentile}) OVER() AS {alias}")
    return columns


def get_staging_table_queries(signals: List[HarmsPortalSignal]) -> List[HarmsPortalQuery]:
    input_queries = [get_staging_table_query(signal) for signal in signals]
    output_queries = []
    for query in input_queries:
        output_queries.extend(
            query + input_query for input_query in input_queries if query.identifiers != input_queires.identifiers
        )
    return output_queries
    
    


def get_staging_table_query(
    signal: HarmsPortalSignal,
) -> Dict[HarmsPortalSignal, List[HarmsPortalQuery]]:
    if signal.signal_type == SignalType.CONTINUOUS:
        tablename = signal.surface.value + "_alias"
        return {
            signal: [
                HarmsPortalQuery(
                    tablename=tablename,
                    select_columns=get_all_metric_columns(),
                    filters=[f"{signal.column} <= {signal.signal.value}_p{i}"],
                    identifiers=[f"{signal.signal.value}_p{i}"],
                )
                for i in range(10, 100, 10)
            ]
        }

    if signal.signal_type == SignalType.BINARY:
        tablename = signal.surface.value + "_alias"
        return {
            signal: [
                HarmsPortalQuery(
                    tablename=tablename,
                    select_columns=get_all_metric_columns(),
                    filters=[signal.column],
                    identifiers=[signal.signal.value],
                )
            ]
        }

    if signal.signal_type == SignalType.CATEGORICAL:
        tablename = signal.surface.value + "_alias"
        return {
            signal: [
                HarmsPortalQuery(
                    tablename=tablename,
                    select_columns=get_all_metric_columns() + [signal.column],
                    filters=[],
                    group_clauses=[signal.column],
                    identifiers=[signal.signal.value],
                )
            ]
        }
    else:
        raise Exception(f"Invalid signal type provided! {signal}")


def get_signal_type(signal: Signal) -> SignalType:
    if signal in {
        Signal.GROUP_CERT_SCORE,
        Signal.GROUP_CONTENT_TAKEDOWNS,
        Signal.GROUP_NUM_COMMENT_ACTORS,
        Signal.GROUP_RANK_BY_VPV,
        Signal.GROUP_TENURE,
    }:
        return SignalType.CONTINUOUS
    else:
        return SignalType.CATEGORICAL


def get_column(signal: Signal) -> str:
    if signal == Signal.GROUP_CERT_SCORE:
        return "cert_score"
    elif signal == Signal.GROUP_CONTENT_TAKEDOWNS:
        return "n_takedowns"
    elif signal == Signal.GROUP_NUM_COMMENT_ACTORS:
        return "num_comment_actors"
    elif signal == Signal.GROUP_RANK_BY_VPV:
        return "rank_by_vpv"
    elif signal == Signal.GROUP_TENURE:
        return "DATE_DIFF('DAY', FROM_UNIXTIME(groupcreatetime), DATE_PARSE('<DATEID>', '%Y-%m-%d'))"

    raise Exception(f"Invalid continuous signal! {signal.value}")
