import csv
import json

def load_config(path):
    with open(path, encoding="utf-8") as f:
        field_map, ref_map = json.load(f)
    return field_map, ref_map

def process(input_csv, output_csv, field_map, ref_map):
    with open(input_csv, encoding="iso-8859-1") as infile, \
         open(output_csv, "w", newline="", encoding="utf-8") as outfile:

        reader = csv.DictReader(infile)
        writer = csv.DictWriter(outfile, fieldnames=list(field_map.values()))
        writer.writeheader()

        for row in reader:
            cleaned = {
                field_map["Transaktionsdag"]: row["Transaktionsdag"].strip(),
                field_map["Referens"]: ref_map.get(row["Referens"].strip(), row["Referens"].strip()),
                field_map["Beskrivning"]: row["Beskrivning"].strip(),
                field_map["Belopp"]: row["Belopp"].strip().replace(" ", "").replace(",", ".")
            }
            writer.writerow(cleaned)

if __name__ == "__main__":
    field_map, ref_map = load_config("config.json")
    process("historical_payments.csv", "processed_transactions.csv", field_map, ref_map)
