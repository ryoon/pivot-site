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
    <xsl:import href="common.xsl"/>

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
                <link href="/styles/pivot.css" rel="stylesheet" type="text/css"/>
                <link href="/styles/pivot_print.css" rel="stylesheet" type="text/css" media="print"/>
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
</xsl:stylesheet>
