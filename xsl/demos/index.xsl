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

    <!-- Override content area to show demos index -->
    <xsl:template name="content">
        <ul class="featuredDemos">
            <p style="padding-bottom:20px;">
                <em>
                    Note: all demos require <a href="http://www.java.com/">Java 6</a> or greater.
                </em>
            </p>

	        <h2>Featured Demos</h2>
            <xsl:for-each select="$project/featured-demos/demo">
                <xsl:variable name="id" select="@id"/>
                <xsl:choose>
                    <xsl:when test="$project/external-demos/demo[@id=$id]">
                        <xsl:variable name="demo" select="$project/external-demos/demo[@id=$id]"/>
                        <xsl:element name="li">
                            <xsl:if test="position()=last()">
                                <xsl:attribute name="style">margin-right:0;</xsl:attribute>
                            </xsl:if>
                            <h2><xsl:value-of select="$demo/properties/title"/></h2>
                            <div class="featuredDemosBox">
                                <p class="featuredDemoImg">
                                    <xsl:element name="a">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$demo/@href"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="target">_new</xsl:attribute>
                                        <img src="/{@screenshot}" alt="{$demo/properties/title}"/>
                                    </xsl:element>
                                </p>
                                <p class="featuredDemoDesc">
                                    <xsl:value-of select="$demo/properties/description"/>
                                </p>
                                <p class="featuredDemoView">
                                    <xsl:element name="a">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$demo/@href"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="target">_new</xsl:attribute>
                                        <xsl:text>View</xsl:text>
                                    </xsl:element>
                                </p>
                            </div>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="document" select="document(concat($trunk, '/demos/www/', $id, '.xml'))/document"/>
                        <xsl:element name="li">
                            <xsl:if test="position()=last()">
                                <xsl:attribute name="style">margin-right:0;</xsl:attribute>
                            </xsl:if>
                            <h2><xsl:value-of select="$document/properties/title"/></h2>
                            <div class="featuredDemosBox">
                                <p class="featuredDemoImg">
                                    <xsl:element name="a">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="concat('/demos/', $id, '.html')"/>
                                        </xsl:attribute>
                                        <xsl:if test="boolean($document/properties/full-screen)">
                                            <xsl:attribute name="target">_new</xsl:attribute>
                                        </xsl:if>
                                        <img src="/{@screenshot}" alt="{$document/properties/title}"/>
                                    </xsl:element>
                                </p>
                                <p class="featuredDemoDesc">
                                    <xsl:value-of select="$document/properties/description"/>
                                </p>
                                <p class="featuredDemoView">
                                    <xsl:element name="a">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="concat('/demos/', $id, '.html')"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="style">text-align:left;</xsl:attribute>
                                        <xsl:if test="boolean($document/properties/full-screen)">
                                            <xsl:attribute name="target">_new</xsl:attribute>
                                        </xsl:if>
                                        <xsl:text>Applet</xsl:text>
                                    </xsl:element>
                                    -
                                    <xsl:element name="a">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="concat('/demos/', $id, '.jnlp')"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="style">text-align:right;</xsl:attribute>
                                        <xsl:text>Web Start</xsl:text>
                                    </xsl:element>
                                </p>
                            </div>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>


        <ul class="otherDemos">
            <br/>
        </ul>

        <ul class="otherDemos">
	        <h2>Other Demos</h2>
            <xsl:for-each select="$demo-index/body//document-item">
                <xsl:variable name="id" select="@id"/>
                <xsl:if test="not($project/featured-demos/demo[@id=$id])">
                    <xsl:variable name="document" select="document(concat($trunk, '/demos/www/', $id, '.xml'))/document"/>
                    <li>
                        <strong><xsl:value-of select="$document/properties/title"/></strong>
                        <em><xsl:value-of select="$document/properties/description"/></em>
                        <div class="btnView">
                            <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('/demos/', $id, '.html')"/>
                                </xsl:attribute>
                                <xsl:if test="boolean($document/properties/full-screen)">
                                    <xsl:attribute name="target">_new</xsl:attribute>
                                </xsl:if>
                                <span>View</span>
                            </xsl:element>
                        </div>
                    </li>
                </xsl:if>
            </xsl:for-each>
        </ul>
    </xsl:template>
</xsl:stylesheet>
