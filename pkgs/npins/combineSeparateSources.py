import json
import os

# File names of the input JSON files
input_files = ['appSources.json', 'extSources.json', 'theSources.json']

# Output file name
output_file = 'sources.json'

# Initialize the final data structure
final_data = {
    "pins": {},
    "version": 5
}

# Iterate through each input file and merge the "pins" data
for file_name in input_files:
    if os.path.exists(file_name):
        with open(file_name, 'r') as f:
            data = json.load(f)
            if "pins" in data:
                final_data["pins"].update(data["pins"])
    else:
        print(f"Warning: {file_name} does not exist and will be skipped.")

# Write the merged data to the output file
with open(output_file, 'w') as f:
    json.dump(final_data, f, indent=2)

print(f"All pins have been concatenated into {output_file}")
