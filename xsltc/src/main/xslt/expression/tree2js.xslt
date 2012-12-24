<xsl:stylesheet
        version="1.1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exslt="http://exslt.org/common"
        exclude-result-prefixes="exslt">

    <xsl:import href="../util.xslt"/>

    <xsl:template match="*" mode="tree-to-javascript">
        <xsl:param name="expects-value"/>
        <xsl:param name="value-variable-name"/>
        <xsl:param name="node-variable-name"/>

        <xsl:choose>
            <xsl:when test="name(.) = 'child' or name(.) = 'variable' or name(.) = 'word'">
                <xsl:text>stylesheet.xpath(node, params)</xsl:text>
                <!-- indicates leading / -->
                <xsl:if test="count(*) = 1">
                    <xsl:text>.root()</xsl:text>
                </xsl:if>
                <xsl:apply-templates select="." mode="xpath-tree-to-javascript"/>
                <xsl:choose>
                    <xsl:when test="$expects-value = 'true'">
                        <xsl:text>.value()</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>.nodes()</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="expression-tree-to-javascript"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="word" mode="xpath-tree-to-javascript">
        <xsl:text>.children(function(childNode){return childNode.name() == "</xsl:text><xsl:value-of select="text()"/><xsl:text>"</xsl:text>
        
        <xsl:if test="count(./*) > 0">
            <xsl:text> &amp;&amp; (</xsl:text>
            <xsl:apply-templates select="./*" mode="tree-to-javascript">

            </xsl:apply-templates>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:text>; })</xsl:text>
        <!--
        <xsl:apply-templates select="*" mode="xpath-tree-to-javascript">
            <xsl:with-param name="skip-child">true</xsl:with-param>
        </xsl:apply-templates>
        -->
    </xsl:template>

    <xsl:template match="function" mode="expression-tree-to-javascript">
        <xsl:text>stylesheet.callFunction(</xsl:text>
        <xsl:choose>
            <xsl:when test="@namespace">
                <xsl:text>"</xsl:text><xsl:value-of select="@namespace"/><xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>null</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>, "</xsl:text><xsl:value-of select="@name"/><xsl:text>"</xsl:text>
        <xsl:for-each select="parameter">
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="*" mode="expression-tree-to-javascript"/>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
        <!--
        <xsl:apply-templates select="*" mode="xpath-tree-to-javascript">
            <xsl:with-param name="skip-child">true</xsl:with-param>
        </xsl:apply-templates>
        -->
    </xsl:template>

    <xsl:template match="equals" mode="expression-tree-to-javascript">
        <xsl:apply-templates select="." mode="expression-tree-to-javascript-infix">
            <xsl:with-param name="operator">==</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

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
            <xsl:apply-templates select="." mode="tree-to-javascript">
                <xsl:with-param name="expects-value">true</xsl:with-param>
            </xsl:apply-templates>
        </xsl:for-each>
        <xsl:text>)</xsl:text>

    </xsl:template>

    <xsl:template match="number-literal|boolean-literal" mode="expression-tree-to-javascript">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="string-literal" mode="expression-tree-to-javascript">
        <xsl:text>&quot;</xsl:text><xsl:value-of select="."/><xsl:text>&quot;</xsl:text>
    </xsl:template>

    <xsl:template match="*" mode="expression-tree-to-javascript">
        <!-- must be an xpath expression -->
        <xsl:apply-templates select="." mode="tree-to-javascript">
            <xsl:with-param name="expects-value">true</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

</xsl:stylesheet>