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
    <xsl:import href="../auxilliary.xsl"/>

    <xsl:variable name="tutorial-index" select="document(concat($trunk, '/tutorials/www/index.xml'))/document"/>

    <!-- Override group navigation to pull from the tutorials index -->
    <xsl:template name="group-navigation">
        <xsl:for-each select="$tutorial-index/body//document-item">
            <xsl:variable name="id" select="@id"/>
            <xsl:variable name="document" select="document(concat($trunk, '/tutorials/www/', $id, '.xml'))/document"/>
            <li>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat($root, 'tutorials/', $id, '.html')"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="$document/properties/title" mode="value"/>
                </xsl:element>
            </li>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
