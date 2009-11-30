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
    <xsl:import href="auxilliary.xsl"/>

    <!-- Override group navigation to pull from the demos index -->
    <xsl:template name="group-navigation">
        <xsl:apply-templates select="$demos-index/body//application-item"/>
    </xsl:template>

    <!-- Override content area to show demos index -->
    <xsl:template name="content">
        <ul class="featuredDemos">
            <xsl:for-each select="application-item[boolean(@featured)]">
                <xsl:choose>
                    <xsl:when test="remote">
                        <xsl:call-template name="featured-demo">
                            <xsl:with-param name="id" select="@id"/>
                            <xsl:with-param name="title" select="properties/title"/>
                            <xsl:with-param name="description" select="properties/description"/>
                            <xsl:with-param name="href" select="remote/@href"/>
                            <xsl:with-param name="new-window" select="@new-window"/>
                            <xsl:with-param name="last" select="position()=last()"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="demo" select="document(concat($demos, '/', @id, '.xml'))/document"/>
                        <xsl:call-template name="featured-demo">
                            <xsl:with-param name="id" select="@id"/>
                            <xsl:with-param name="title" select="$demo/properties/title"/>
                            <xsl:with-param name="description" select="$demo/properties/description"/>
                            <xsl:with-param name="href" select="concat($base, 'demos/', @id, '.html')"/>
                            <xsl:with-param name="new-window" select="@new-window"/>
                            <xsl:with-param name="last" select="position()=last()"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>

        <h2>Other Demos</h2>
        <ul class="otherDemos">
            <xsl:for-each select="application-item[not(boolean(@featured))]">
                <xsl:choose>
                    <xsl:when test="remote">
                        <xsl:call-template name="other-demo">
                            <xsl:with-param name="title" select="properties/title"/>
                            <xsl:with-param name="description" select="properties/description"/>
                            <xsl:with-param name="href" select="remote/@href"/>
                            <xsl:with-param name="new-window" select="@new-window"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="demo" select="document(concat($demos, '/', @id, '.xml'))/document"/>
                        <xsl:call-template name="other-demo">
                            <xsl:with-param name="title" select="$demo/properties/title"/>
                            <xsl:with-param name="description" select="$demo/properties/description"/>
                            <xsl:with-param name="href" select="concat($base, 'demos/', @id, '.html')"/>
                            <xsl:with-param name="new-window" select="@new-window"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template name="featured-demo">
        <xsl:param name="id"/>
        <xsl:param name="title"/>
        <xsl:param name="description"/>
        <xsl:param name="href"/>
        <xsl:param name="new-window"/>
        <xsl:param name="last"/>

        <xsl:element name="li">
            <xsl:if test="boolean($last)">
                <xsl:attribute name="style">margin-right:0;</xsl:attribute>
            </xsl:if>
            <h2><xsl:value-of select="$title"/></h2>
            <div class="featuredDemosBox">
                <xsl:if test="$project/demo-screenshots/screenshot[@id=$id]">
                    <xsl:variable name="src">
                        <xsl:value-of select="$base"/>
                        <xsl:value-of select="$project/demo-screenshots/screenshot[@id=$id]"/>
                    </xsl:variable>
                    <p class="featuredDemoImg">
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of select="$href"/>
                            </xsl:attribute>
                            <xsl:if test="boolean($new-window)">
                                <xsl:attribute name="target">_new</xsl:attribute>
                            </xsl:if>
                            <img src="{$src}" alt="{$title}"/>
                        </xsl:element>
                    </p>
                </xsl:if>
                <p class="featuredDemoDesc">
                    <xsl:value-of select="$description"/>
                </p>
                <p class="featuredDemoView">
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$href"/>
                        </xsl:attribute>
                        <xsl:if test="boolean($new-window)">
                            <xsl:attribute name="target">_new</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="'View'"/>
                    </xsl:element>
                </p>
            </div>
        </xsl:element>
    </xsl:template>

    <xsl:template name="other-demo">
        <xsl:param name="title"/>
        <xsl:param name="description"/>
        <xsl:param name="href"/>
        <xsl:param name="new-window"/>

        <li>
            <strong><xsl:value-of select="$title"/></strong>
            <em><xsl:value-of select="$description"/></em>
            <div class="btnView">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$href"/>
                    </xsl:attribute>
                    <xsl:if test="boolean($new-window)">
                        <xsl:attribute name="target">_new</xsl:attribute>
                    </xsl:if>
                    <span>View</span>
                </xsl:element>
            </div>
        </li>
    </xsl:template>
</xsl:stylesheet>
