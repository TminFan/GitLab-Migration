#python
import json
import os

def get_all_projects(data):
    projects = []
    for project in data:
        projects.append(project["name"])
    
    projects_dict = {"projects": projects}
    outfile_path = os.path.join(os.getcwd(), "parsed.json")
    with open(outfile_path, "w") as outfile:
        json.dump(projects_dict, outfile)
    
    return projects

if __name__ == "__main__":
    file_path = os.path.join(os.getcwd(), "all_gitlab_group_projects.json")

    with open(file_path, "r") as f:
        data = json.load(f)

    get_all_projects(data)