# GitLab Repository and Pipelines Migration Automation

This repository leverages GitHub Actions, the Actions Importer tool, GitLab and GitHub REST APIs and various Git commands to automate the migration of repositories and pipelines from GitLab to GitHub. This process is designed to streamline the transfer of codebases and CI/CD configurations, ensuring a seamless transition to GitHub.

A GitLab repository's pipeline migration involves creating a new GitHub workflow YAML file by converting the GitLab CI/CD YAML syntax to GitHub Actions syntax, and then creating a new merge request in the migrated repository on GitHub.

To generate pipeline migration report without proceeding with the pipeline migration, you can run the workflow in audit mode [Audit Pipeline Migration](#audit-pipeline-migration)

### Table of Contents
- [Prerequisites](#Prerequisites)
- [Getting Started](#getting-started)
    - [Single repository migration](#single-repository-migration)
    - [Bulk Repositories Migration](#bulk-repositories-migration)
    - [Single Repository Pipeline Migration](#single-repository-pipelines-migration)
    - [Audit Pipeline Migration](#audit-pipeline-migration)

## Prerequisites

To begin using this migration tool, either fork or clone the **ecs_gitlab_migration** repository to your GitHub account.

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

## Getting Started
Repositories and pipelines are migrated using manually triggered GitHub Actions workflows, which require specific user inputs to tailor the migration process to individual requirements. **Before running any workflows, please ensure that you understand the required input parameters for each workflow.**

The migration tools are located in the Actions Page. To use the tools, follow these steps:

1. Navigate to the Actions page: Go to the 'Actions' tab in your GitHub repository.
2. Select the Workflow: Under the 'All workflows' section, find and select the corresponding migration tool. For example, migrating individual GitLab repository is _**migrate-gitlab-repo**_.
3. Run the Workflow: Click on the 'Run workflow' dropdown button located on the left side of the page.
4. Enter Workflow Arguments: Fill out all required fields, which are marked with a red asterisk ('*').
5. Initiate Migration: After entering all necessary information, press the 'Run workflow' button at the bottom of the dropdown to start the migration process.

## Single Repository Migration

The individual GitLab repository migration is handled by the _**migrate-gitlab-repo**_ workflow on the Actions page. This workflow migrates a single repository from the user’s GitLab personal namespace or group namespace:

### Workflow input parameters

<table>
<thead>
<tr><th>Input Fields</th><th>Field Description</th><th>Option</th><th>Default Value</th><th>Value Type</th></tr>
</thead>
<tbody>
<tr>
<td>GitHub user name</td><td>User personal user name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<td>GitHub repo name</td><td>New GitHub repository name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr><td>GitLab user name</td><td>User personal namespace or group namespace</td><td>Required</td><td>None</td><td>String</td></tr>
<tr>
<td>GitLab repo full path</td><td>Fully Qualified Domain Name e.g. https://gitlab.com/user-account/project1</td><td>Required</td><td>None</td><td>String</td>
</tr>
</tbody>
</table>

## Bulk Repositories Migration

The bulk migration of GitLab repositories is handled by the _**bulk-migration**_ workflow on the Actions page. This workflow offers two options for bulk repository migration:

1. Bulk migrating repositories from the user's GitLab personal namespace to their GitHub personal account.
2. Bulk migrating repositories from the user's GitLab group namespace to a GitHub organization account.

### Workflow input parameters

<table>
<thead>
<tr><th>Input Fields</th><th>Field Description</th><th>Option</th><th>Default Value</th><th>Value Type</th></tr>
</thead>
<tbody>
<tr>
<td>Group migrating option</td><td>Selecting the option box initiates the workflow for bulk migrating repositories from a GitLab group namespace to a GitHub organization account. Deselecting the option box cancels this operation.</td><td>Optional</td><td>Not for group migration</td><td>Boolean</td>
</tr>
<tr>
<td>GitHub user name or organization name</td><td>If you are not migrating group repositories, enter your personal username. Otherwise, enter the organization name.</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<tr><td>GitLab personal namespace or group namespace</td><td>If you are not migrating group repositories, enter your personal namespace. Otherwise, enter the group namespace.</td><td>Required</td><td>None</td><td>String</td></tr>
<tr>
<td>GitLab base instance url</td><td>The link to the GitLab you're trying to connect to</td><td>Optional</td><td>https://gitlab.com or https://gitlab.example.com</td><td>String</td>
</tbody>
</table>

## Single Repository Pipelines Migration

The migration of a single repository's pipeline is handled by the _**migrate-gitlab-pipeline**_ workflow on the Actions page. Please ensure that the  _Audit pipeline migration?_ option box remains unclicked.

### Workflow input parameters

<table>
<thead>
<tr><th>Input Fields</th><th>Field Description</th><th>Option</th><th>Default Value</th><th>Value Type</th></tr>
</thead>
<tbody>
<tr>
<td>Audit pipeline migration?</td><td>Leaving this option box unclicked will enable the pipeline migration.</td><td>required</td><td>false</td><td>Boolean</td>
</tr>
<tr>
<td>GitHub user name</td><td>GitHub personal user name or organization name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<td>GitHub repo name</td><td>Existing GitHub repository name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<td>GitLab user name or group name or group ID</td><td>GitLab personal user name or group name or group ID</td><td>Required</td><td>None</td><td>String</td></tr>
<tr>
<td>GitLab repo name</td><td>Existing GitLab repository name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<td>GitLab base instance url</td><td>The link to the GitLab you're trying to connect to</td><td>Optional</td><td>https://gitlab.com or https://gitlab.example.com</td><td>String</td>
</tr>
</tbody>
</table>

## Audit Pipeline Migration

Before proceeding with the pipeline migration, users have the option to view an audit report, which aids in assessing the migration setup and requirements. The pipeline migration audit is conducted through the _**migrate-gitlab-pipeline**_ workflow on the Actions page by selecting the _**Audit pipeline migration?**_. By activating this option, the workflow will generate a pipeline migration audit report without proceeding with the actual migration.

The results of the audit will provide valuable insights into the current configuration and readiness of the pipelines for migration, ensuring a smooth transition to GitHub.

### Workflow input parameters

<table>
<thead>
<tr><th>Input Fields</th><th>Field Description</th><th>Option</th><th>Default Value</th><th>Value Type</th></tr>
</thead>
<tbody>
<tr>
<td>Audit pipeline migration?</td><td>Clicking this box to allow audit process</td><td>required</td><td>false</td><td>Boolean</td>
</tr>
<tr>
<td>GitHub user name</td><td>GitHub personal user name or organization name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<td>GitHub repo name</td><td>Existing GitHub repository name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<td>GitLab user name or group name or group ID</td><td>The auditing mode currently only allows repositories in a GitLab group. The input can only be the group name or group ID.</td><td>Required</td><td>None</td><td>String</td></tr>
<tr>
<td>GitLab repo name</td><td>Existing GitLab repository name</td><td>Required</td><td>None</td><td>String</td>
</tr>
<tr>
<td>GitLab base instance url</td><td>The link to the GitLab you're trying to connect to</td><td>Optional</td><td>https://gitlab.com or https://gitlab.example.com</td><td>String</td>
</tr>
</tbody>
</table>

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