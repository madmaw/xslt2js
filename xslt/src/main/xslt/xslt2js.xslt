<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


    <xsl:import href="expr2js.xslt"/>
    <xsl:import href="util.xslt"/>


    <xsl:output method="text"/>
    <xsl:preserve-space elements="*"/>

    <xsl:param name="top-level-function-name"/>
    <xsl:param name="tab">&#160;&#160;</xsl:param>

    <xsl:template match="xsl:stylesheet">
        <xsl:param name="indent"><xsl:text>
</xsl:text></xsl:param>
        <xsl:variable name="next-indent" select="concat($indent, $tab)"/>

        <xsl:apply-templates select="." mode="comment">
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:apply-templates>

        <!-- assume we have a stylesheet element -->
        <xsl:value-of select="$indent"/>
        <xsl:if test="$top-level-function-name">
            <xsl:value-of select="$top-level-function-name"/><xsl:text> = </xsl:text>
        </xsl:if>
        <xsl:text>(function(xslt2js) {</xsl:text>
        <xsl:value-of select="$next-indent"/><xsl:text>var stylesheet = {};</xsl:text>
        <xsl:value-of select="$next-indent"/><xsl:text>var defaultTemplates = [];</xsl:text>
        <xsl:value-of select="$next-indent"/><xsl:text>var modalTemplates = {};</xsl:text>
        <xsl:value-of select="$next-indent"/><xsl:text>var namedTemplates = {};</xsl:text>
        <xsl:value-of select="$next-indent"/><xsl:text>stylesheet.defaultTemplates = defaultTemplates;</xsl:text>
        <xsl:value-of select="$next-indent"/><xsl:text>stylesheet.modalTemplates = modalTemplates;</xsl:text>
        <xsl:value-of select="$next-indent"/><xsl:text>stylesheet.namedTemplates = namedTemplates;</xsl:text>
        <xsl:for-each select="xsl:template">
            <xsl:choose>
                <xsl:when test="@name">
                    <xsl:value-of select="$next-indent"/><xsl:text>namedTemplates["</xsl:text><xsl:value-of select="@name"/><xsl:text>"] = </xsl:text>
                </xsl:when>
                <xsl:when test="@mode">
                    <xsl:value-of select="$next-indent"/><xsl:text>if(!modalTemplates["</xsl:text><xsl:value-of select="@name"/><xsl:text>"]){</xsl:text>
                    <xsl:value-of select="$next-indent"/><xsl:text>  modalTemplates["</xsl:text><xsl:value-of select="@name"/><xsl:text>"] = [];</xsl:text>
                    <xsl:value-of select="$next-indent"/><xsl:text>}</xsl:text>
                    <xsl:value-of select="$next-indent"/><xsl:text>modalTemplates["</xsl:text><xsl:value-of select="@name"/><xsl:text>"].push(</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$next-indent"/><xsl:text>defaultTemplates.push(</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select=".">
                <xsl:with-param name="indent" select="$next-indent"/>
            </xsl:apply-templates>
            <xsl:if test="string-length(@mode) > 0 or string-length(@name) = 0">
                <xsl:text>);</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="$next-indent"/><xsl:text>return stylesheet;</xsl:text>
        <xsl:value-of select="$indent"/><xsl:text>})();</xsl:text>
    </xsl:template>

    <xsl:template match="xsl:template">
        <xsl:param name="indent"/>
        <xsl:param name="resultNode">resultNode</xsl:param>
        <xsl:variable name="next-indent" select="concat($indent, $tab)"/>
        <xsl:variable name="next-next-indent" select="concat($next-indent, $tab)"/>

        <xsl:text>{</xsl:text>

        <xsl:apply-templates select="." mode="comment">
            <xsl:with-param name="indent" select="$next-indent"/>
        </xsl:apply-templates>

        <!-- add the matcher -->
        <xsl:if test="@match">
            <xsl:value-of select="$next-indent"/><xsl:text>match:function(node, params){ </xsl:text>

            <xsl:value-of select="$next-next-indent"/>
            <xsl:text>return </xsl:text>
            <xsl:apply-templates select="@match" mode="expression-compile">
                <xsl:with-param name="nodeVariableName">node</xsl:with-param>
                <xsl:with-param name="valuesVariableName">params</xsl:with-param>
            </xsl:apply-templates>
            <xsl:text>;</xsl:text>

            <xsl:value-of select="$next-indent"/><xsl:text>},</xsl:text>
        </xsl:if>
        <xsl:if test="@priority">
            <xsl:value-of select="$next-indent"/><xsl:text>priority:</xsl:text><xsl:value-of select="@priority"/><xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:value-of select="$next-indent"/><xsl:text>transformation:function(node, </xsl:text><xsl:value-of select="$resultNode"/><xsl:text>, params){</xsl:text>
        <xsl:value-of select="$next-next-indent"/><xsl:text>var values = xslt2js.createScope(params);</xsl:text>
        <xsl:apply-templates select="*" mode="code">
            <xsl:with-param name="indent" select="$next-next-indent"/>
            <xsl:with-param name="resultNode" select="$resultNode"/>
        </xsl:apply-templates>
        <xsl:value-of select="$next-indent"/><xsl:text>}</xsl:text>

        <xsl:value-of select="$indent"/><xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="xsl:copy-of" mode="code" priority="2">
        <xsl:param name="indent"/>
        <xsl:param name="resultNode"/>

        <xsl:apply-templates select="." mode="comment">
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:apply-templates>

        <!-- TODO almost certainly should treat as a list -->
        <xsl:value-of select="$indent"/><xsl:text>xslt2js.carefulAppendNodes(</xsl:text><xsl:value-of select="$resultNode"/><xsl:text>, xslt2js.carefulCloneNodes(</xsl:text>
        <xsl:apply-templates select="@select" mode="expression-compile">

        </xsl:apply-templates>
        <xsl:text>));</xsl:text>

    </xsl:template>

    <xsl:template match="*" mode="code" priority="1">
        <xsl:param name="indent"/>
        <xsl:param name="resultNode"/>

        <xsl:apply-templates select="." mode="comment">
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:apply-templates>
        <xsl:choose>
            <xsl:when test="starts-with(name(.), 'xsl:')">
                <xsl:message>
                    ERROR: <xsl:value-of select="name(.)"/> is not handled! Skipping!
                </xsl:message>
                <xsl:value-of select="$indent"/><xsl:text>// unrecognised XSL element, implementation skipped!</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <!-- add a shallow copy of this node directly -->
                <xsl:variable name="childNode"><xsl:value-of select="$resultNode"/>_1</xsl:variable>

                <!-- var child = copy -->
                <xsl:value-of select="$indent"/>
                <xsl:text>var </xsl:text><xsl:value-of select="$childNode"/><xsl:text> = xslt2js.createNode("</xsl:text><xsl:value-of select="name(.)"/><xsl:text>");</xsl:text>

                <!-- TODO add in the attributes -->
                <xsl:for-each select="@*">
                    <xsl:value-of select="$indent"/>
                    <xsl:text>xslt2js.setAttribute(</xsl:text>
                    <xsl:value-of select="$childNode"/><xsl:text>, "</xsl:text><xsl:value-of select="name(.)"/>
                    <xsl:text>", </xsl:text>
                    <xsl:choose>
                        <!-- TODO test for this better -->
                        <xsl:when test="contains(., '{') and contains(., '}')">

                            <!-- TODO extract the expression and apply it (we need to trim off those {} brackets) -->
                            <xsl:apply-templates select="." mode="expression-compile">
                                <!-- TODO what is the scope of this expression? -->
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>"</xsl:text>
                            <xsl:value-of select="string(.)"/>
                            <xsl:text>"</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>);</xsl:text>
                </xsl:for-each>

                <!-- result.append(child) -->
                <xsl:value-of select="$indent"/>
                <xsl:text>xslt2js.appendNode(</xsl:text><xsl:value-of select="$resultNode"/><xsl:text>, </xsl:text><xsl:value-of select="$childNode"/><xsl:text>);</xsl:text>

                <!-- add in the children -->
                <xsl:apply-templates select="*" mode="code">
                    <xsl:with-param name="indent" select="$indent"/>
                    <xsl:with-param name="resultNode" select="$childNode"/>
                </xsl:apply-templates>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



</xsl:stylesheet>