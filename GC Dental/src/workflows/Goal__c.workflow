<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Goals_Deactivate_FU</fullName>
        <field>isActive__c</field>
        <literalValue>0</literalValue>
        <name>Goals Deactivate FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Goals Deactivate</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Goal__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Goals_Deactivate_FU</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Goal__c.End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
