import sys
import pathlib


field_type_mapping = {
    "CHAR": "TEXT",
    "INTEGER": "INTEGER",
    "BIGINT": "INTEGER",
    "TIMESTAMP": "TEXT",
    "VARCHAR": "TEXT",
    "DATE": "TEXT",
}


filename = pathlib.Path(sys.argv[1])
table_name = filename.stem.rsplit("_", 1)[0]

print("CREATE table {} (".format(table_name))

field_defs = []
has_rpt_id = False

with open(filename) as f:
    next(f)
    next(f)
    for line in f:
        name = line[:55].strip().lower()
        nullable = line[55:64].strip()
        field_type = field_type_mapping[line[64:].strip()]

        definition = "{} {} {}".format(name, field_type, nullable)
        if name == "oid":
            definition += " PRIMARY KEY"
        elif table_name == "lm_data" and name == "rpt_id":
            definition += " PRIMARY KEY"

        if name == "rpt_id":
            has_rpt_id = True

        field_defs.append(definition)

if table_name != "lm_data" and has_rpt_id:
    field_defs += ["FOREIGN KEY(rpt_id) REFERENCES lm_data(rpt_id)"]

print(", ".join(field_defs))
print(");")
