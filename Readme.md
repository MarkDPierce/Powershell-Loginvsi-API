# 🤖Powershell API Module for Login Enterprise🚀

~ ***Mood is something for cattle and love making.👋***

**Powershell module to interact with the version 4 API of Login Enterprise.**
___

## 🚩Table of Contents

- [🤖Powershell API Module for Login Enterprise🚀](#powershell-api-module-for-login-enterprise)
  - [🚩Table of Contents](#table-of-contents)
  - [📦 Requirements](#-requirements)
    - [Powershell](#powershell)
    - [Login Enterprise](#login-enterprise)
  - [🆕 Getting Started](#-getting-started)
  - [📉 Results](#-results)
      - [How to read the results](#how-to-read-the-results)
  - [🔩 Under the Hood](#-under-the-hood)
  - [🦮 Contributing & Developing](#-contributing--developing)
  - [📱 Troubleshooting](#-troubleshooting)
- [🔬 Adjusting](#-adjusting)


## 📦 Requirements

### Powershell
| Name | Description | Version
| --- | --- | --- |
| Powershell  | Scripting Language | 4 > |

### Login Enterprise
|       Name              | Description |
| ----------------------- | ----------- |
| Login Enterprise Appliance | Required for APIs |

## 🆕 Getting Started
___

Quick-start:
```Powershell
<#
    Modify the apiconfig.json file
        - Add the correct URL to your Appliance installation
        - Header section is only important for full Oauth2,
    In the directory you have cloned/downloaded the module to.
#>
Import-Module LoginVSI-API

#Generate sets of all tokens and will put the key under a global variable
Grant-AllScopeTokens

Get-Accounts

```

## 📉 Results
___

#### How to read the results
**TODO:**


## 🔩 Under the Hood
___
**TODO:**



## 🦮 Contributing & Developing
___
**TODO:**

I'll be your guide dog.


## 📱 Troubleshooting
___
**TODO:**


# 🔬 Adjusting
___

**TODO:**
