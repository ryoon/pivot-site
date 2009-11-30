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
    <xsl:import href="project.xsl"/>

    <!-- Override <body> to translate to the auxilliary body HTML -->
    <xsl:template match="body">
        <div id="contentBase" class="group">
            <h1><xsl:value-of select="//document/properties/title"/></h1>
            <ul class="naviLeft">
                <xsl:call-template name="group-navigation"/>
            </ul>
            <div class="content">
                <xsl:call-template name="content"/>
            </div>
        </div>
    </xsl:template>

    <!-- Left side-bar group navigation -->
    <xsl:template name="group-navigation">
        <xsl:apply-templates select="$project/item-groups/item-group[@id=$item-group]/item"/>
    </xsl:template>

    <!-- Auxilliary content area -->
    <xsl:template name="content">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- <section> translates to an anchor, a title, and nested content -->
    <xsl:template match="section">
        <div class="section">
            <xsl:variable name="name">
                <xsl:apply-templates select="@name">
                    <xsl:with-param name="value-only">true</xsl:with-param>
                </xsl:apply-templates>
            </xsl:variable>
            <a name="{$name}"><h2><xsl:value-of select="$name"/></h2></a>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="subsection">
        <!-- TODO -->
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
