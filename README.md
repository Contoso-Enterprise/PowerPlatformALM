
# PowerPlatform ALM
Repository used to host Power Platform ALM with Dataverse for demo and lab purpose.

# FILEPATH: export-solution-dev(action).yml

 This YAML file contains the configuration for the "export-solution-dev" action.

The "export-solution-dev" action is responsible for exporting a solution in a development environment.

## Usage:
- name: Export Solution (Dev)
  uses: your-org/export-solution-dev-action@v1
  with:
    solution-name: 'My Solution'
    output-folder: './exported-solutions'

## Inputs:
- solution-name: The name of the solution to export.
- output-folder: The folder where the exported solution will be saved.

## Outputs:
 - exported-solution-path: The path to the exported solution file.

## Example:
- name: Export Solution (Dev)
  uses: your-org/export-solution-dev-action@v1
  with:
    solution-name: 'My Solution'
    output-folder: './exported-solutions'

# pack-solution(action).yml

This YAML file defines the configuration for the "pack-solution" action.
The action is responsible for packaging a solution in a specific format.

## Inputs:
 - solution-file: The path to the solution file that needs to be packaged.
 - output-folder: The folder where the packaged solution will be saved.

## Outputs:
 - packaged-solution: The path to the packaged solution file.

## Example usage:
 - name: Pack Solution
   uses: some-action/pack-solution@v1
   with:
     solution-file: ./path/to/solution.sln
     output-folder: ./path/to/output


# deploy-managed-solution(action).yml
This YAML file contains the configuration for deploying a managed solution.
It is used as an action in a CI/CD pipeline to automate the deployment process.

## Parameters:
- solutionName: The name of the managed solution to deploy.
- environment: The target environment where the solution will be deployed.
- connection: The connection string or credentials for accessing the target environment.

## Steps:
1. Connect to the target environment using the provided connection string or credentials.
2. Retrieve the managed solution file based on the provided solution name.
3. Deploy the managed solution to the target environment.
4. Log the deployment status and any errors encountered during the deployment process.

## Usage:
- name: Deploy Managed Solution
  uses: my-org/deploy-managed-solution-action@v1
  with:
    solutionName: 'MySolution'
    environment: 'Production'
    connection: ${{ secrets.CONNECTION_STRING }}

# deploy-unmanaged-solution(action).yml
This YAML file contains the configuration for deploying an unmanaged solution.
It is used to define the steps and actions required to deploy the solution to a target environment.

## Steps:
1. Authenticate with the target environment.
2. Retrieve the unmanaged solution file.
3. Validate the solution file.
4. Deploy the solution to the target environment.
5. Perform post-deployment tasks.

## Usage:
- name: Deploy Unmanaged Solution
  uses: your-action-repo/deploy-unmanaged-solution-action@v1
  with:
    solution-file: 'path/to/solution.zip'
    target-environment: 'https://example.com'
    username: ${{ secrets.USERNAME }}
    password: ${{ secrets.PASSWORD }}