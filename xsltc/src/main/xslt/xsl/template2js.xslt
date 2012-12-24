<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="xsl:template" mode="xslt2js" priority="1">
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
            <xsl:apply-templates select="@match" mode="expression2js">
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
        <xsl:value-of select="$next-next-indent"/><xsl:text>var values = stylesheet.createScope(params);</xsl:text>
        <xsl:apply-templates select="*" mode="xslt2js">
            <xsl:with-param name="indent" select="$next-next-indent"/>
            <xsl:with-param name="resultNode" select="$resultNode"/>
        </xsl:apply-templates>
        <xsl:value-of select="$next-indent"/><xsl:text>}</xsl:text>

        <xsl:value-of select="$indent"/><xsl:text>}</xsl:text>
    </xsl:template>

</xsl:stylesheet>