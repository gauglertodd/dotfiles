# Copyright 2004-present Facebook. All Rights Reserved.

import itertools
from dataclasses import (
    dataclass,
    field,
)
from typing import (
    List,
)

from eau.harms_portal.join_info import JoinInfo


def dedupe(l1: List[str], l2: List[str]):
    return list(set(itertools.chain(l1, l2)))


@dataclass
class HarmsPortalQuery(object):
    tablename: str
    select_columns: List[str]
    join_clause: List[JoinInfo] = field(default_factory=list)
    filters: List[str] = field(default_factory=list)
    group_clauses: List[str] = field(default_factory=list)
    raw_columns: List[str] = field(default_factory=list)
    identifiers: List[str] = field(default_factory=str)

    def __add__(self, hpq):
        assert (
            self.tablename == hpq.tablename
        ), f"Tablenames must match: {self.tablename} != {hpq.tablename}"
        return HarmsPortalQuery(
            tablename = self.tablename,
            select_columns =  dedupe(self.select_columns, hpq.select_columns),
            filters =  dedupe(self.filters, hpq.filters),
            group_clauses= dedupe(self.group_clauses, hpq.group_clauses),
            raw_columns = dedupe(self.raw_columns, hpq.raw_columns),
            identifiers = self.identifiers.extend(hpq.identifiers),
        )

    def __eq__(self, hpq):
        return set(self.identifiers) == set(hpq.identifiers)

    def get_string(
        self,
        include_join: bool = True,
        include_filters: bool = True,
        include_group_by: bool = True,
    ) -> str:

        select_statements = []
        join_clauses = []
        filter_clauses = []
        group_by_clauses = []

        select_statements.extend(
            [f"{self.tablename}.{col}" for col in self.select_columns]
        )
        select_statements.extend(self.raw_columns)
        select_statements.extend(
            f"{join.target_table}.{column}"
            for join in self.join_clause
            for column in join.new_columns
        )

        if include_join:
            join_clauses.extend(join.get_join_statement() for join in self.join_clause)

        if include_filters:
            filter_clauses.extend(self.filters)

        if include_group_by:
            group_by_clauses.extend(self.group_clauses)

        return """
        SELECT
            {select_query}
        FROM {tablename}
            {join_clauses}
            {filter_clauses}
            {group_clauses}
        """.format(
            select_query=", \n".join(select_statements),
            tablename=self.tablename,
            join_clauses="\n".join(join_clauses),
            filter_clauses=(len(filter_clauses) > 0) * " WHERE "
            + "\n AND ".join(filter_clauses),
            group_clauses=(len(group_by_clauses) > 0) * " GROUP BY "
            + " , ".join(group_by_clauses),
        )
