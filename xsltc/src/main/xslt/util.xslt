<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="indent-spacing">&#160;&#160;</xsl:param>

    <xsl:template name="line-prefix">
        <xsl:param name="indent"/>
        <xsl:text>
</xsl:text>
        <xsl:call-template name="line-prefix-space">
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="line-prefix-space">
        <xsl:param name="indent"/>
        <xsl:if test="$indent > 0">
            <xsl:value-of select="$indent-spacing"/>
            <xsl:call-template name="line-prefix-space">
                <xsl:with-param name="indent" select="$indent - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <xsl:template match="text()" mode="comment">
        <xsl:param name="indent"/>
        <xsl:value-of select="$indent"/><xsl:text>// &lt;</xsl:text><xsl:value-of select="name(.)"/><xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="*" mode="comment">
        <xsl:param name="indent"/>
        <xsl:value-of select="$indent"/><xsl:text>// &lt;</xsl:text><xsl:value-of select="name(.)"/>
        <xsl:for-each select="@*">
            <xsl:text> </xsl:text><xsl:value-of select="name(.)"/><xsl:text>="</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
        </xsl:for-each>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>


</xsl:stylesheet>