targetScope = 'subscription'
param policyDefinitionId string
param assignmentName string
param location string
param roledefinitionIds array
param solutionTag string
//param utcValue string = utcNow()
//var roleassignmentnamePrefix=guid('${assignmentName}-${subscription().subscriptionId}')


resource assignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: assignmentName
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  properties: {
      policyDefinitionId: policyDefinitionId
      displayName: assignmentName
      enforcementMode: 'Default'
      metadata: {
        createdBy: solutionTag
      }
  }
}

resource roleassignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roledefinitionId, i) in roledefinitionIds:  {
  name: guid(guid('${assignmentName}-${subscription().subscriptionId}-${i}'))
  properties: {
    roleDefinitionId: roledefinitionId
    principalId: assignment.identity.principalId
    principalType: 'ServicePrincipal'
    description: 'Role assignment for ${assignmentName} with "${guid('${assignmentName}-${subscription().subscriptionId}-${i}')}" role definition id.'
  }
}]
output roleassignmentId0 string = roleassignment[0].name
output roleassignmentId1 string = roleassignment[1].name

