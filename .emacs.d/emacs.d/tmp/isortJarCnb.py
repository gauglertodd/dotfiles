#!/usr/bin/env python3

from __future__ import (
    absolute_import,
    division,
    print_function,
    unicode_literals,
)
import fblearner.flow.api as flow
import logging
import pandas as pd
from typing import (
    Dict,
    List,
    Tuple,
)

LOG = logging.getLogger(__name__)


def getFlowDir(run_id: str):
    run_id = (
        run_id
        if flow.get_flow_environ().is_local_run
        else f"f{str(flow.get_flow_environ().workflow_run_id)}"
    )
    return f"{run_id}"


@flow.memoized(version="v0")
def getHPRGInputFilename(fbtype: str) -> str:
    return f"ACDC_HPRG_inputs_{fbtype}.csv"


@flow.decorators.operator()
@flow.memoized(version="v1")
def getAssetTypesDict(
    asset_ids: List[int], asset_types: List[int], gbl_asset_types: Dict[int, str]
) -> Dict[str, List[int]]:
    type_dict = {}
    for i in range(len(asset_ids)):
        asset_id = asset_ids[i]
        asset_type = asset_types[i]

        if asset_type not in gbl_asset_types.keys():
            LOG.error(f"Asset type {asset_type} not supported for id {asset_id}")
            continue

        asset_type_name = gbl_asset_types[asset_type]

        if asset_type_name not in type_dict:
            type_dict[asset_type_name] = []

        type_dict[asset_type_name].append(asset_id)

    return type_dict


@flow.memoized(version="v0")
def getGeneratedRulesFilename(fbtype: str) -> str:
    return f"ACDC_generated_rules_{fbtype}.json"


@flow.memoized(version="v0")
def getHPRGOutputFilename(fbtype: str) -> str:
    return f"ACDC_hprg_output_{fbtype}.txt"


@flow.memoized(version="v0")
def getParentDirectory(path: str) -> str:
    return "/".join(path.split("/")[:-1])


@flow.memoized(version="v0")
def getFilenameFromPath(path: str) -> str:
    return path.split("/")[-1]


@flow.memoized(version="v0")
def getBucketPathFromFullPath(path: str) -> List[str]:
    return path.split("/", 1)


@flow.decorators.operator()
@flow.memoized(version="v1")
def get_dict_with_first_from_tuple_str(
    input_dict: Dict[str, Tuple[str, str]]
) -> Dict[str, str]:
    return {fbtype: first for fbtype, (first, _) in input_dict.items()}


@flow.decorators.operator()
@flow.memoized(version="v1")
def get_dict_with_second_from_tuple_str(
    input_dict: Dict[str, Tuple[str, str]]
) -> Dict[str, str]:
    return {fbtype: second for fbtype, (_, second) in input_dict.items()}


@flow.decorators.operator()
def get_dict_with_first_from_tuple_df_with_errors(
    input_dict: Dict[str, Tuple[pd.DataFrame, str, List[str]]]
) -> Dict[str, pd.DataFrame]:
    return {fbtype: first for fbtype, (first, _, _) in input_dict.items()}


@flow.decorators.operator()
def get_dict_with_first_from_tuple_df(
    input_dict: Dict[str, Tuple[pd.DataFrame, str]]
) -> Dict[str, pd.DataFrame]:
    return {fbtype: first for fbtype, (first, _) in input_dict.items()}


@flow.decorators.operator()
def get_dict_with_second_from_tuple_df_with_errors(
    input_dict: Dict[str, Tuple[pd.DataFrame, str, List[str]]]
) -> Dict[str, str]:
    return {fbtype: second for fbtype, (_, second, _) in input_dict.items()}


@flow.decorators.operator()
def get_dict_with_third_from_tuple_df_with_errors(
    input_dict: Dict[str, Tuple[pd.DataFrame, str, List[str]]]
) -> Dict[str, List[str]]:
    return {fbtype: third for fbtype, (_, _, third) in input_dict.items()}


@flow.decorators.operator()
def get_dict_with_second_from_tuple_df(
    input_dict: Dict[str, Tuple[pd.DataFrame, str]]
) -> Dict[str, str]:
    return {fbtype: second for fbtype, (_, second) in input_dict.items()}


@flow.decorators.operator()
def get_dict_with_df(
    input_dict: Dict[str, Dict[str, Tuple[str, pd.DataFrame, str]]]
) -> Dict[str, Dict[str, pd.DataFrame]]:
    return {
        fbtype: {model_name: df for model_name, (_, df, _) in model_name_dict.items()}
        for fbtype, model_name_dict in input_dict.items()
    }


@flow.decorators.operator()
def get_dict_with_description(
    input_dict: Dict[str, Dict[str, Tuple[str, pd.DataFrame, str]]]
) -> Dict[str, Dict[str, str]]:
    return {
        fbtype: {
            model_name: description
            for model_name, (description, _, _) in model_name_dict.items()
        }
        for fbtype, model_name_dict in input_dict.items()
    }


@flow.decorators.operator()
def get_dict_with_manifold(
    input_dict: Dict[str, Dict[str, Tuple[str, pd.DataFrame, str]]]
) -> Dict[str, Dict[str, str]]:
    return {
        fbtype: {
            model_name: manifold_path
            for model_name, (_, _, manifold_path) in model_name_dict.items()
        }
        for fbtype, model_name_dict in input_dict.items()
    }
