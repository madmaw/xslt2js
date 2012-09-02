<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="xsl:stylesheet" mode="xslt2js" priority="1">
        <xsl:param name="indent"><xsl:text>
</xsl:text></xsl:param>
        <xsl:variable name="next-indent" select="concat($indent, $tab)"/>
        <xsl:variable name="next-next-indent" select="concat($next-indent, $tab)"/>
        <xsl:variable name="next-next-next-indent" select="concat($next-next-indent, $tab)"/>

        <xsl:apply-templates select="." mode="comment">
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:apply-templates>

        <!-- assume we have a stylesheet element -->
        <xsl:value-of select="$indent"/>
        <xsl:if test="$top-level-function-name">
            <xsl:value-of select="$top-level-function-name"/><xsl:text> = </xsl:text>
        </xsl:if>
        <xsl:text>(function(xslt2js) {</xsl:text>
        <xsl:value-of select="$next-indent"/><xsl:text>var stylesheet = new TransformationStylesheet();</xsl:text>
        <xsl:for-each select="xsl:template">
            <xsl:choose>
                <xsl:when test="@name">
                    <xsl:value-of select="$next-indent"/><xsl:text>stylesheet.addNamedTemplate("</xsl:text>
                    <xsl:value-of select="@name"/>
                    <xsl:text>", </xsl:text>
                    <xsl:apply-templates select="." mode="xslt2js">
                        <xsl:with-param name="indent" select="$next-indent"/>
                    </xsl:apply-templates>
                    <xsl:text>);</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$next-indent"/><xsl:text>stylesheet.addTemplate(</xsl:text>

                    <!-- match -->
                    <xsl:value-of select="$next-next-indent"/><xsl:text>function(node, params){ </xsl:text>
                    <xsl:value-of select="$next-next-next-indent"/>
                    <xsl:text>return </xsl:text>
                    <xsl:apply-templates select="@match" mode="expression2js">
                        <xsl:with-param name="nodeVariableName">node</xsl:with-param>
                        <xsl:with-param name="valuesVariableName">params</xsl:with-param>
                    </xsl:apply-templates>
                    <xsl:text>;</xsl:text>
                    <xsl:value-of select="$next-next-indent"/><xsl:text>}, </xsl:text>

                    <!-- transform -->
                    <xsl:value-of select="$next-next-indent"/><xsl:text>function(node, resultNode, params){ </xsl:text>
                    <xsl:value-of select="$next-next-next-indent"/><xsl:text>var values = xslt2js.createScope(params);</xsl:text>
                    <xsl:apply-templates select="*" mode="xslt2js">
                        <xsl:with-param name="indent" select="$next-next-next-indent"/>
                        <xsl:with-param name="resultNode">resultNode</xsl:with-param>
                    </xsl:apply-templates>
                    <xsl:value-of select="$next-next-indent"/><xsl:text>}, </xsl:text>

                    <!-- mode -->
                    <xsl:value-of select="$next-next-indent"/>
                    <xsl:choose>
                        <xsl:when test="@mode">
                            <xsl:text>"</xsl:text><xsl:value-of select="@mode"/><xsl:text>"</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>null</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>, </xsl:text>

                    <!-- priority -->
                    <xsl:value-of select="$next-next-indent"/>
                    <xsl:choose>
                        <xsl:when test="@priority">
                            <xsl:value-of select="@priority"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>null</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="$next-indent"/><xsl:text>);</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:value-of select="$next-indent"/><xsl:text>return stylesheet;</xsl:text>
        <xsl:value-of select="$indent"/><xsl:text>})();</xsl:text>
    </xsl:template>

</xsl:stylesheet>