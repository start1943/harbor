// Copyright (c) 2017 VMware, Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

*** Settings ***
Documentation  Harbor BATs
Resource  ../../resources/Util.robot
Suite Setup  Nightly Test Setup  ${ip}  ${SSH_PWD}  ${HARBOR_PASSWORD}  ${ip1}
Suite Teardown  Collect Nightly Logs  ${ip}  ${SSH_PWD}  ${ip1}
Default Tags  Nightly

*** Variables ***
${HARBOR_URL}  https://${ip}
${SSH_USER}  root
${HARBOR_ADMIN}  admin

*** Test Cases ***
Test Case - Ldap Verify Cert
    Init Chrome Driver
    Sign In Harbor  ${HARBOR_URL}  ${HARBOR_ADMIN}  ${HARBOR_PASSWORD}
    Switch To Configure
    Test LDAP Server Success
    Close Browser

Test Case - Ldap Sign in and out
    Init Chrome Driver
    Sign In Harbor  ${HARBOR_URL}  mike  zhu88jie
    Close Browser

Test Case - Ldap User Create Project
    Init Chrome Driver
    ${d}=    Get Current Date    result_format=%m%s
    Sign In Harbor  ${HARBOR_URL}  mike  zhu88jie
    Create An New Project  project${d}
    Logout Harbor
    Manage Project Member  ${HARBOR_ADMIN}  ${HARBOR_PASSWORD}  project${d}  mike02  Add
    Close Browser

Test Case - Ldap User Push An Image
    Init Chrome Driver
    ${d}=    Get Current Date    result_format=%m%s
    Sign In Harbor  ${HARBOR_URL}  mike  zhu88jie
    Create An New Project  project${d}
    
    Push Image  ${ip}  mike  zhu88jie  project${d}  hello-world:latest
    Go Into Project  project${d}
    Wait Until Page Contains  project${d}/hello-world
    Close Browser

Test Case - Ldap User Can Not login
    Docker Login Fail  ${ip}  test  123456