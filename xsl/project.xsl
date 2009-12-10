<?xml version="1.0" encoding="UTF-8"?>
<!--
Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to you under the Apache License,
Version 2.0 (the "License"); you may not use this file except in
compliance with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- Parameters (overrideable) -->
    <xsl:param name="version"/>
    <xsl:param name="trunk"/>

    <!-- Variables (not overrideable) -->
    <xsl:variable name="version-token">{$version}</xsl:variable>
    <xsl:variable name="wiki-token">{$wiki}</xsl:variable>
    <xsl:variable name="asf-token">{$asf}</xsl:variable>
    <xsl:variable name="jira-token">{$jira}</xsl:variable>
    <xsl:variable name="wiki">http://cwiki.apache.org/PIVOT</xsl:variable>
    <xsl:variable name="asf">http://www.apache.org</xsl:variable>
    <xsl:variable name="jira">http://issues.apache.org/jira/browse/PIVOT</xsl:variable>
    <xsl:variable name="project" select="document('project.xml')/project"/>

    <!-- <version> gets translated to the current version (text) -->
    <xsl:template match="version">
        <xsl:value-of select="$version"/>
    </xsl:template>

    <!-- Attributes get passed through with variable resolution -->
    <xsl:template match="@*">
        <xsl:attribute name="{name(.)}">
            <xsl:apply-templates select="." mode="value"/>
        </xsl:attribute>
    </xsl:template>

    <!-- Value mode attributes get variable resolution but just pass the attribute value -->
    <xsl:template match="@*" mode="value">
        <xsl:choose>
            <xsl:when test="contains(., $version-token)">
                <xsl:value-of select="substring-before(., $version-token)"/>
                <xsl:value-of select="$version"/>
                <xsl:value-of select="substring-after(., $version-token)"/>
            </xsl:when>
            <xsl:when test="contains(., $wiki-token)">
                <xsl:value-of select="substring-before(., $wiki-token)"/>
                <xsl:value-of select="$wiki"/>
                <xsl:value-of select="substring-after(., $wiki-token)"/>
            </xsl:when>
            <xsl:when test="contains(., $asf-token)">
                <xsl:value-of select="substring-before(., $asf-token)"/>
                <xsl:value-of select="$asf"/>
                <xsl:value-of select="substring-after(., $asf-token)"/>
            </xsl:when>
            <xsl:when test="contains(., $jira-token)">
                <xsl:value-of select="substring-before(., $jira-token)"/>
                <xsl:value-of select="$jira"/>
                <xsl:value-of select="substring-after(., $jira-token)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Elements and comments get passed through -->
    <xsl:template match="*|comment()">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()|comment()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Value mode elements and comments get their child nodes passed through -->
    <xsl:template match="*|comment()" mode="value">
        <xsl:apply-templates select="*|text()|comment()"/>
    </xsl:template>
</xsl:stylesheet>
