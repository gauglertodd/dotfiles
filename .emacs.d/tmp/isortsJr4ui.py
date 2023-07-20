#!/usr/bin/env python3
from f6.core.data.dataframe import DataFrame
from f6.datasets.integrity.eau.common import (categories_map as CATEGORIES_MAP,
                                              nonrec_label_encoding as
                                              LABEL_ENCODING,)
from f6.lang.tensor import TensorType
from f6.modules.core.trainers.label_encoder_trainer import EncoderModel
from f6.transforms.models.label_encoder import LabelEncoder
from f6.transforms.static.cast import Cast
from f6.transforms.static.concat_tensors import (ConcatTensorAndPresence,
                                                 ConcatTensors,)
from f6.transforms.static.encode_categories import EncodeCategories
import metastore
from typing import Dict
from typing_extensions import Literal


def cast_columns_to_tensor(df, columns):
    available_columns = []
    for col in columns:
        if col.name not in set(df.schema.keys()):
            continue

        if col.type == "bigint":
            df[col.name] = Cast(TensorType[float, Literal[1]], df[col.name])

        elif col.type == "map<bigint,bigint>":
            df[col.name] = ConcatTensorAndPresence(
                EncodeCategories(
                    CATEGORIES_MAP[col.name], Cast(Dict[str, float], df[col.name])
                )
            )

        elif col.type == "map<string,bigint>":
            df[col.name] = ConcatTensorAndPresence(
                EncodeCategories(
                    CATEGORIES_MAP[col.name], Cast(Dict[str, float], df[col.name])
                )
            )

        elif col.type == "map<string,double>":
            df[col.name] = ConcatTensorAndPresence(
                EncodeCategories(
                    CATEGORIES_MAP[col.name], Cast(Dict[str, float], df[col.name])
                )
            )

        elif col.type == "map<string,map<double,bigint>>":
            continue

        elif (
            col.type
            == "map<string,struct<t10:bigint,t25:bigint,t50:bigint,t75:bigint,t90:bigint,t95:bigint>>"
        ):
            continue

        elif col.type == "float":
            df[col.name] = Cast(TensorType[float, Literal[1]], df[col.name])

        elif col.type == "string":
            continue
            df[col.name] = ConcatTensorAndPresence(
                EncodeCategories(CATEGORIES_MAP[col.name], df[col.name])
            )

        available_columns.append(col.name)
    return available_columns


def example_fetcher(
    table_name: str,
    namespace: str,
    label_conditions: str,
    set_name: str,
    filter_conditions: str,
    set_name_filter: str,
) -> DataFrame:
    m = metastore.metastore(namespace=namespace)
    table = m.get_table(table_name)
    columns = table.sd.cols

    columns_to_select = []
    for col in columns:
        if col.type == "float":
            columns_to_select.append(
                f"""
                CASE
                    WHEN IS_NAN({col.name})
                    THEN 0.0
                    ELSE {col.name}
                END
                """
            )

        if col.type == "bigint":
            columns_to_select.append(
                f"""
                CASE
                    WHEN IS_NAN({col.name})
                    THEN 0
                    ELSE {col.name}
                END
                """
            )

        if col.type in {
            "map<string,bigint>",
            "map<string,double>",
            "string",
        }:
            columns_to_select.append(col.name)
        elif col.type == "map<bigint,bigint>":
            columns_to_select.append(
                f"CAST({col.name} AS map<varchar,bigint>) as {col.name}"
            )
    feature_columns = ",".join(columns_to_select)

    df = DataFrame.from_sql(
        sql=f"""
        SELECT
            {feature_columns},
            {label_conditions},
            {set_name}
        FROM {table_name}
        WHERE
            {filter_conditions}
        """,
        namespace=namespace,
    ).where(f"set_name = '{set_name_filter}'")

    feature_columns = cast_columns_to_tensor(df, columns)
    encoder = EncoderModel(
        module=LabelEncoder(
            encoding=LABEL_ENCODING,
            should_encode_unmatched_values=False,
            unmatched_encoding_value=-1,
        )
    )
    df["label"] = encoder(df["label"])
    df["features"] = ConcatTensors(*[df[col] for col in feature_columns])

    return df
