import json
import os

def get_all_projects(data):
    projects = []
    for project in data:
        projects.append(project["name"])
    
    projects_dict = {"projects": projects}
    parser_output_dir = "parser_outputs"
    outfile_path = os.path.join(os.getcwd(), parser_output_dir, "parsed.json")
    with open(outfile_path, "w") as outfile:
        json.dump(projects_dict, outfile)
    
    return projects

if __name__ == "__main__":
    json_file_dir = "api_calls_info"
    file_path = os.path.join(os.getcwd(), json_file_dir, "all_gitlab_group_projects.json")

    with open(file_path, "r") as f:
        data = json.load(f)

    get_all_projects(data)