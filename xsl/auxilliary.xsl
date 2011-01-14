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
    <!-- Import parent stylesheet -->
    <xsl:import href="html.xsl"/>

    <xsl:variable name="document-group" select="/document/@group"/>

    <!-- Auxilliary envelope contains a title, the group navigation, and the content -->
    <xsl:template name="envelope">
        <div id="contentBase" class="group">
            <h1>
                <xsl:apply-templates select="/document/properties/title" mode="value"/>
            </h1>
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
        <xsl:for-each select="$project/document-groups/document-group[@id=$document-group]/documents/document">
            <li>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:variable name="location">
                            <xsl:apply-templates select="@href" mode="value"/>
                        </xsl:variable>
                        <xsl:if test="not(starts-with($location, 'http://'))">
                            <xsl:value-of select="'/'"/>
                        </xsl:if>
                        <xsl:value-of select="$location"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </li>
        </xsl:for-each>
    </xsl:template>

    <!-- Content area -->
    <xsl:template name="content">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- <section> and <subsection> translate to an anchor, a title, and nested content -->
    <xsl:template match="section|subsection">
        <div class="{name(.)}">
            <xsl:variable name="name">
                <xsl:apply-templates select="@name" mode="value"/>
            </xsl:variable>
            <a name="{$name}"><h2><xsl:value-of select="$name"/></h2></a>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
</xsl:stylesheet>
