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

    <!-- Override content area to show tutorials index -->
    <xsl:template name="content">
        <div class="section">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- <item-group> gets translated to a properly indented list -->
    <xsl:template match="item-group">
        <h3><xsl:value-of select="@name"/></h3>
        <ul style="list-style-type: none; padding-left: 0px; padding-bottom: 15px;">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <!-- <document-item> gets translated to a list item with a hyperlink -->
    <xsl:template match="document-item">
        <xsl:variable name="document" select="document(concat($trunk, '/tutorials/www/', @id, '.xml'))/document"/>
        <li>
            <a href="{@id}.html">
                <xsl:value-of select="$document/properties/title"/>
            </a>
            <xsl:if test="*">
                <xsl:element name="ul">
                    <xsl:attribute name="style">list-style-type: none; padding-left: 20px;</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:if>
        </li>
    </xsl:template>
</xsl:stylesheet>
