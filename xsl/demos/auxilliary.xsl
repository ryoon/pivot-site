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
    <xsl:import href="../auxilliary.xsl"/>

    <xsl:param name="root"/>

    <!--Override css to check for full-screen demos -->
    <xsl:template name="css">
        <xsl:choose>
            <xsl:when test="boolean(/document/properties/full-screen)">
                <style type="text/css">
                    * {
                        padding: 0px;
                        margin: 0px;
                    }

                    html, body {
                        height: 100%;
                        overflow: hidden;
                    }
                </style>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-imports/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Override body to check for full-screen demos -->
    <xsl:template match="body" mode="value">
        <xsl:choose>
            <xsl:when test="boolean(/document/properties/full-screen)">
                <xsl:apply-templates select="//application"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-imports/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- <root> gets resolved to the 'root' XSL parameter -->
    <xsl:template match="root">
      <!-- TODO -->
    </xsl:template>

    <!-- <application> translates to Javascript that creates an applet -->
    <xsl:template match="application">
        <script type="text/javascript" src="http://java.com/js/deployJava.js"></script>
        <script type="text/javascript">
            <!-- Base attributes -->
            var attributes = {
                code:"org.apache.pivot.wtk.BrowserApplicationContext$HostApplet",
                width:"<xsl:value-of select="@width"/>",
                height:"<xsl:value-of select="@height"/>"
            };

            <!-- Additional attributes -->
            <xsl:for-each select="attributes/*">
                attributes.<xsl:value-of select="name(.)"/> = '<xsl:value-of select="."/>';
            </xsl:for-each>

            <!-- Archive attribute -->
            var libraries = [];
            <xsl:variable name="signed" select="libraries/@signed"/>
            <xsl:for-each select="libraries/library">
                <xsl:text><![CDATA[libraries.push("]]></xsl:text>
                <xsl:value-of select="'lib/pivot-'"/>
                <xsl:value-of select="."/>
                <xsl:value-of select="'-'"/>
                <xsl:value-of select="$version"/>
                <xsl:if test="$signed">
                    <xsl:value-of select="'.signed'"/>
                </xsl:if>
                <xsl:value-of select="'.jar'"/>
                <xsl:text><![CDATA[");
                ]]></xsl:text>
            </xsl:for-each>
            attributes.archive = libraries.join(",");

            <!-- Base parameters -->
            var parameters = {
                codebase_lookup:false,
                java_arguments:"-Dsun.awt.noerasebackground=true -Dsun.awt.erasebackgroundonresize=true",
                application_class_name:"<xsl:value-of select="@class"/>"
            };

            <!-- Startup properties -->
            <xsl:if test="startup-properties">
                var startupProperties = [];
                <xsl:for-each select="startup-properties/*">
                    startupProperties.push("<xsl:value-of select="name(.)"/>=<xsl:apply-templates/>");
                </xsl:for-each>
                parameters.startup_properties = startupProperties.join("&amp;");
            </xsl:if>

            deployJava.runApplet(attributes, parameters, "1.6");
        </script>
    </xsl:template>
</xsl:stylesheet>
