import json
import os
import sys

def get_workflow_artifacts_ids(data):
    all_ids = []
    for artifact in data["artifacts"]:
        all_ids.append(artifact["id"])
        print(f"artifact id: {artifact['id']}")

    artifacts_ids_dict = {"artifacts_ids": all_ids}
    outfile_path = os.path.join(os.getcwd(), "artifact_info_parsed.json")
    with open(outfile_path, "w") as f:
        json.dump(artifacts_ids_dict, f)

    return all_ids

if __name__ == "__main__":
    file_name = sys.argv[1]
    file_path = os.path.join(os.getcwd(), file_name)

    with open(file_path, "r") as f:
        data = json.load(f)

    get_workflow_artifacts_ids(data)