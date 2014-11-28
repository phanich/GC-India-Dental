<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DemoProduct_Deactivate_FU</fullName>
        <field>is_active__c</field>
        <literalValue>0</literalValue>
        <name>DemoProduct Deactivate FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Demo Product Deactivate</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Demo_Product__c.To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DemoProduct_Deactivate_FU</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Demo_Product__c.To__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
