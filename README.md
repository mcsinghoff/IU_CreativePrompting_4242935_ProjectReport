# IU Creative Prompting Project Report Resources

This repository contains supporting technical resources for my project report in the IU course **DLMPAIECPT01 – Project: AI Excellence with Creative Prompting Techniques**.

## Project Topic

The project implements an **AI-assisted workflow for Azure consultants**. The workflow supports the creation, review, improvement, documentation, and safe preparation of PowerShell artifacts for **Microsoft Entra ID user onboarding from CSV files**.

The workflow is implemented with **n8n** and generative AI. It is intentionally designed as an assistive engineering workflow and not as autonomous production automation.

## Repository Content

```text
ResourceCode/
├── n8n_Workflow_IU_Project_PromptingTechniques.json
└── azure_resourcegroup_n8n.bicep
```

## Files

| File                                               | Purpose                                                                                                                                                                                                                                                               |
| -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `n8n_Workflow_IU_Project_PromptingTechniques.json` | Exported n8n workflow used for the project implementation. It contains the AI-assisted workflow steps for requirement structuring, script generation, script review, script improvement, documentation generation, artifact packaging, and Azure Blob Storage upload. |
| `azure_resourcegroup_n8n.bicep`                    | Azure Bicep template used as supporting infrastructure code for the Azure resource group / n8n environment setup.                                                                                                                                                     |

## Workflow Summary

The n8n workflow follows this simplified process:

```text
consultant input
→ requirement specification
→ PowerShell script draft
→ AI script review
→ improved script
→ documentation and test artifacts
→ artifact package
→ Azure Blob Storage upload
```

The generated artifact package includes files such as:

```text
requirement-specification.md
Create-EntraUsers.ps1
risk-review.md
Create-EntraUsers-v2.ps1
README.md
users-template.csv
test-checklist.md
prompt-library.md
run-summary.md
```

## Important Safety Boundary

The workflow does **not** execute PowerShell scripts.

The workflow does **not** create or modify Microsoft Entra ID users.

The workflow does **not** perform production changes automatically.

Instead, it creates reviewable artifacts that must be checked, tested, and approved by a human Azure engineer before any real execution.

## Technologies Used

| Category               | Used in the Project                        |
| ---------------------- | ------------------------------------------ |
| Workflow automation    | n8n                                        |
| Cloud platform         | Microsoft Azure                            |
| Identity platform      | Microsoft Entra ID                         |
| Infrastructure as Code | Azure Bicep                                |
| Artifact storage       | Azure Blob Storage                         |
| Scripting context      | PowerShell with Microsoft Graph PowerShell |
| AI model               | GPT-4o-mini                                |
| Input format           | CSV                                        |
| Hosting model          | Self-hosted n8n on Ubuntu Server           |

## Purpose for University Review

This repository is provided as technical evidence for the project report. It shows the implemented workflow and supporting infrastructure artifact used during the project.

The written project report explains the goals, implementation, results, limitations, and ethical reflection. This repository supports that report by making the technical implementation easier to inspect.
