<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="xsl:copy-of" mode="xslt2js" priority="2">
        <xsl:param name="indent"/>
        <xsl:param name="resultNode"/>

        <xsl:apply-templates select="." mode="comment">
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:apply-templates>

        <xsl:value-of select="$indent"/><xsl:value-of select="$resultNode"/><xsl:text>.append(xslt2js.clone(</xsl:text>
        <xsl:value-of select="$resultNode"/><xsl:text>, </xsl:text>
        <xsl:apply-templates select="@select" mode="expression2js">

        </xsl:apply-templates>
        <xsl:text>));</xsl:text>

    </xsl:template>

</xsl:stylesheet>