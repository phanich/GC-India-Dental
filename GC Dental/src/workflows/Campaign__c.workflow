<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Campaign_DeactivateFU</fullName>
        <field>isActive__c</field>
        <literalValue>0</literalValue>
        <name>Campaign_DeactivateFU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Campaign_Deactivate</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign__c.Deactivation_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow is used for deactivating the campaign once the deactivation date is reached.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Campaign_DeactivateFU</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign__c.Deactivation_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
