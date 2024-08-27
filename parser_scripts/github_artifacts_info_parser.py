import json
import os

def get_workflow_artifacts_ids(data):
    all_ids = []
    for artifact in data["artifacts"]:
        all_ids.append(artifact["id"])
        print(f"artifact id: {artifact['id']}")

    artifacts_ids_dict = {"artifacts_ids": all_ids}
    parser_output_dir = "parser_outputs"
    outfile_path = os.path.join(os.getcwd(), parser_output_dir, "artifact_info_parsed.json")
    with open(outfile_path, "w") as f:
        json.dump(artifacts_ids_dict, f)

    return all_ids

if __name__ == "__main__":
    json_file_dir = "api_calls_info"
    file_path = os.path.join(os.getcwd(), json_file_dir, "parse_artifacts.json")

    with open(file_path, "r") as f:
        data = json.load(f)

    get_workflow_artifacts_ids(data)