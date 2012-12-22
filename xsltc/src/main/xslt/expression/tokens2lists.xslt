<xsl:stylesheet
        version="1.1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exslt="http://exslt.org/common"
        exclude-result-prefixes="exslt">

<xsl:import href="../util.xslt"/>

    <xsl:template match="*" mode="expression-tokens-to-lists" priority="1">
        <xsl:param name="from" select="@index"/>

        <xsl:variable name="index" select="@index"/>

        <xsl:copy-of select="."/>

        <xsl:variable name="next">
            <xsl:apply-templates select="../*[@index = $index+1]" mode="expression-tokens-to-lists">
                <xsl:with-param name="from" select="$from"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:copy-of select="$next"/>

        <xsl:variable name="list-end" select="exslt:node-set($next)/*[1]/list-end/@index"/>

        <xsl:if test="$list-end">
            <xsl:apply-templates select="../*[@index = $list-end+1]" mode="expression-tokens-to-lists">
                <xsl:with-param name="from" select="$from"/>
            </xsl:apply-templates>
        </xsl:if>

    </xsl:template>

    <xsl:template match="open-bracket|open-square-bracket" mode="expression-tokens-to-lists" priority="2">
        <xsl:param name="from" select="@index"/>

        <xsl:variable name="index" select="@index"/>

        <list index="{$index}" type="{name()}">
            <!-- reset from -->
            <xsl:apply-templates select="../*[@index = $index + 1]" mode="expression-tokens-to-lists">

            </xsl:apply-templates>
        </list>

    </xsl:template>

    <xsl:template match="close-bracket|close-square-bracket" mode="expression-tokens-to-lists" priority="2">
        <!-- do nothing, we exit the bracketing -->
        <list-end index="{@index}" type="{name()}"/>
    </xsl:template>

</xsl:stylesheet>