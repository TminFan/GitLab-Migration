# GitLab Repository and Pipelines Migration Automation

This repository leverages GitHub Actions, the Actions Importer tool, and various Git commands to automate the migration of repositories and pipelines from GitLab to GitHub. This process is designed to streamline the transfer of codebases and CI/CD configurations, ensuring a seamless transition to GitHub.

## Getting started
To begin using this migration tool, either fork or clone the **ecs_gitlab_migration** repository to your GitHub account.

### Prerequisites
Generate Personal Access Tokens (PATs) for both GitHub and GitLab, and securely store them as repository secrets. These tokens are essential for authenticating and authorizing the migration process between the platforms.

Generating Personal Access Tokens:
1. GitHub PAT:
    - Navigate to your GitHub account settings.
    - Click on 'Developer settings', then 'Personal access tokens'.
    - Click 'Generate new token', select the necessary permissions, and create the token.
    - For a detailed guide, refer to GitHub's official documentation on creating a PAT [GitHub PAT (classic)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic).

2. GitLab PAT:
    - Go to your GitLab profile settings.
    - Under 'Access Tokens', choose 'Add a personal access token'.
    - Set the required permissions for the token and generate it.
    - For more information, see GitLab's guide on personal access tokens [GitLab PAT](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html).

3. Storing Tokens as Secrets:
    - After generating the tokens, store them in your GitHub repository:
    - Go to your repository's settings.
    - Navigate to 'Secrets', then click on 'Actions'.
    - **Create new secrets**, naming them to **GH_TOKEN** for GitHub PAT and **GITLAB_TOKEN** for GitLab PAT.
    - Paste the respective tokens as the values for these secrets.

These tokens will enable secure interactions with GitHub and GitLab APIs during the migration process. For more information, see GitHub's guide on repository secrets [GitHub secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions).

**Select the following permission scopes for GitHub PAT and GitLab PAT**\
GitHub PAT (classic)
- [x] repo
- [x] workflow

GitLab PAT
- [x] api
- [x] read_api

## Migration
Repositories and pipelines are migrated using manually triggered GitHub Actions workflows, which require specific user inputs to tailor the migration process to individual requirements.

### Migrate One Repository from GitLab to GitHub
The repository migration is handled by the repo_migration.yml workflow. To start a migration, follow these steps:

1. Navigate to the Actions Page: Go to the 'Actions' tab in your GitHub repository.
2. Select the Workflow: Under the 'All workflows' section, find and select the migrate-gitlab-repo workflow.
3. Run the Workflow: Click on the 'Run workflow' dropdown button located on the left side of the page.
4. Enter Workflow Arguments: Fill out all required fields, which are marked with a red asterisk ('*').
5. Initiate Migration: After entering all necessary information, press the 'Run workflow' button at the bottom of the dropdown to start the migration process.

This process will migrate the specified repository from GitLab to GitHub according to the parameters you set.

<table>
<thead>
<tr><th>Input Fields</th><th>Field Description</th><th>Option</th><th>Default Value</th><th>Value Type</th></tr>
</thead>
<tbody>
<tr>
<td>GitHub user name</td><td>User account name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<td>GitHub repo name</td><td>New or existing GitHub project name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr><td>GitLab user name</td><td>User account name</td><td>Required</td><td>None</td><td>String</td></tr>
<tr>
<td>GitLab repo full path</td><td>Fully Qualified Domain Name</td><td>Required</td><td>None</td><td>String</td>
</tr>
</tbody>
</table>

### Migrate Multi Repositories from a GitLab Group to a GitHub Organization


### Audit Pipeline Migration for a GitLab Group
Before proceeding with the migration of pipelines, users have the option to view an audit report, which helps in assessing the migration setup and requirements. Follow these steps to generate and view the audit report:

**Steps to Generate the Audit Report**
1. Access the Actions Page:
    - Navigate to the 'Actions' tab in your GitHub repository.

2. Select the Workflow:
    - Under the 'All workflows' dropdown, locate and select the migrate-gitlab-pipeline workflow.

3. Initiate the Audit:
    - Click on the 'Run workflow' dropdown button on the left side of the page.
    - To perform an audit before migration, check the 'Audit pipeline migration?' box.

4. Provide Workflow Arguments:
    - Enter the necessary parameters into the workflow arguments fields. All required fields are marked with a red asterisk ('*').

5. Start the Audit Process:
    - After ensuring all necessary fields are correctly filled, click the 'Run workflow' button at the bottom of the form to begin the auditing process.

The results of the audit will provide valuable insights into the current configuration and readiness of the pipelines for migration, ensuring a smooth transition to GitHub.

**Important Information for Auditing Pipelines Before Migration**

When preparing to audit pipelines prior to their migration from GitLab to GitHub, it is essential to use either the GitLab group name or group ID. This requirement is due to the limitations of the GitLab API endpoint used by the GitHub Actions Importer.

The GitHub Actions Importer utilizes the following GitLab API endpoint to retrieve project information:

<code>https://gitlab_base_instance_url/api/v4/groups/group_name_or_id/projects</code>

This endpoint specifically requires a group name or group ID for accessing projects within a group. Here are the implications:

1. Group Scope: Your GitLab projects must be part of a defined group in GitLab. Standalone projects under a personal user account cannot be accessed using this method.

2. Avoid User Account Names: Providing a GitLab user account name (e.g., JohnDoe) instead of a group name or ID will result in a 404 Not Found error from the API because the endpoint does not support user namespaces for this operation.

To find out your GitLab namespaces and group IDs, you can use the GitLab API below. 
<code>
curl --header "PRIVATE-TOKEN: <your_access_token>" "https://gitlab.example.com/api/v4/namespaces"
</code><br>
For details of GitLab APIs, please refer to [GitLab namespaces API](https://docs.gitlab.com/ee/api/namespaces.html).


#### Migrate Project Pipelines from GitLab to GitHub
The process for migrating pipelines using the GitHub Actions Importer is similar to auditing pipelines, with a simple variation in the workflow options:
**Steps to Migrate Pipelines:**
1. Navigate to the Actions Tab: Go to the 'Actions' tab within your GitHub repository.

2. Select the Migration Workflow:
    - Choose the migrate-gitlab-pipeline workflow listed under 'All workflows'.

3. Configure Workflow:
    - Click on the 'Run workflow' dropdown button located on the left side of the page.
    - **To Migrate (Not Audit)**: Ensure that the 'Audit pipeline migration?' checkbox is not selected.

4. Input Valid Details:
    - For the field labeled 'GitLab user or group name or group id.', only enter a user name or group name. Note: Entering a group ID will result in a '404 Not Found' error.

5. Initiate Migration:
    - After filling out all required fields (marked with a red '*'), press the 'Run workflow' button at the bottom to start the migration process.

This workflow leverages the same setup as the audit process but without selecting the audit option, allowing for a direct migration of pipelines from GitLab to GitHub.

<table>
<thead>
<tr><th>Input Fields</th><th>Field Description</th><th>Option</th><th>Default Value</th><th>Value Type</th></tr>
</thead>
<tbody>
<tr>
<td>Audit pipeline migration?</td><td>Whether audit or not</td><td>Optional</td><td>false</td><td>Boolean</td>
</tr>
<tr>
<td>GitHub user name</td><td>User account name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<td>GitHub repo name</td><td>New or existing GitHub project name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<td>GitLab user name or group name or group ID</td><td>User account name or group name or group ID</td><td>Required</td><td>None</td><td>String</td></tr>
<tr>
<td>GitLab repo name</td><td>Existing GitLab project name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<td>GitLab base instance url</td><td>The link to the GitLab you're trying to connect to</td><td>Optional</td><td>https://gitlab.ecs.vuw.ac.nz</td><td>String</td>
</tr>
</tbody>
</table>