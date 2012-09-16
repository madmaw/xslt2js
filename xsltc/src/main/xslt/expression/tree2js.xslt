<xsl:stylesheet
        version="1.1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exslt="http://exslt.org/common"
        exclude-result-prefixes="exslt">

    <xsl:import href="../util.xslt"/>

    <xsl:template match="multiply" mode="expression-tree-to-javascript">
        <xsl:apply-templates select="." mode="expression-tree-to-javascript-infix">
            <xsl:with-param name="operator">*</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="add" mode="expression-tree-to-javascript">
        <xsl:apply-templates select="." mode="expression-tree-to-javascript-infix">
            <xsl:with-param name="operator">+</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="subtract" mode="expression-tree-to-javascript">
        <xsl:apply-templates select="." mode="expression-tree-to-javascript-infix">
            <xsl:with-param name="operator">-</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="divide" mode="expression-tree-to-javascript">
        <xsl:apply-templates select="." mode="expression-tree-to-javascript-infix">
            <xsl:with-param name="operator">/</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="and" mode="expression-tree-to-javascript">
        <xsl:apply-templates select="." mode="expression-tree-to-javascript-infix">
            <xsl:with-param name="operator"><xsl:text><![CDATA[&&]]></xsl:text></xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="or" mode="expression-tree-to-javascript">
        <xsl:apply-templates select="." mode="expression-tree-to-javascript-infix">
            <xsl:with-param name="operator">||</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*" mode="expression-tree-to-javascript-infix">
        <xsl:param name="operator"/>
        <xsl:text>(</xsl:text>
        <xsl:for-each select="*">
            <xsl:if test="position() > 1">
                <xsl:text> </xsl:text><xsl:value-of select="$operator"/><xsl:text> </xsl:text>
            </xsl:if>
            <xsl:apply-templates select="." mode="expression-tree-to-javascript">

            </xsl:apply-templates>
        </xsl:for-each>
        <xsl:text>)</xsl:text>

    </xsl:template>

    <xsl:template match="number-literal" mode="expression-tree-to-javascript">
        <xsl:value-of select="."/>
    </xsl:template>

</xsl:stylesheet>