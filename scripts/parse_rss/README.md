# kapselistudio-import

Given an RSS XML file, generate SQL import clauses for Kapselistudio.

Just run `elixir parse_rss.exs path/to/rss.xml` and it will write an `inserts.sql` file with the SQL.
