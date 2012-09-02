<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="xsl:apply-templates" mode="xslt2js" priority="1">
        <xsl:param name="indent"/>
        <xsl:param name="resultNode"/>

        <xsl:apply-templates select="." mode="comment">
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:apply-templates>

        <!-- TODO almost certainly should treat as a list -->
        <xsl:value-of select="$indent"/><xsl:text>stylesheet.applyTemplates(</xsl:text>
        <xsl:value-of select="$resultNode"/>
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="@select" mode="expression2js"/>
        <xsl:text>, </xsl:text>
        <xsl:choose>
            <xsl:when test="@mode">
                <xsl:text>"</xsl:text><xsl:value-of select="@mode"/><xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>null</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>);</xsl:text>

    </xsl:template>

</xsl:stylesheet>