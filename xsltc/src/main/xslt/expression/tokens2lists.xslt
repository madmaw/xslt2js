<xsl:stylesheet
        version="1.1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exslt="http://exslt.org/common"
        exclude-result-prefixes="exslt">

<xsl:import href="../util.xslt"/>

    <xsl:template match="*" mode="expression-tokens-to-lists" priority="1">
        <xsl:apply-templates select="." mode="expression-tokens-to-lists-default">
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*" mode="expression-tokens-to-lists-default">
        <xsl:variable name="index" select="@index"/>

        <xsl:copy-of select="."/>

        <xsl:variable name="next">
            <xsl:apply-templates select="../*[@index = $index+1]" mode="expression-tokens-to-lists">
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:copy-of select="$next"/>

        <xsl:variable name="list-end" select="exslt:node-set($next)/*[1]/list-end/@index"/>

        <xsl:if test="$list-end">
            <xsl:apply-templates select="../*[@index = $list-end+1]" mode="expression-tokens-to-lists">
            </xsl:apply-templates>
        </xsl:if>

    </xsl:template>

    <xsl:template match="word" mode="expression-tokens-to-lists" priority="2">
        <xsl:variable name="index" select="@index"/>

        <xsl:variable name="next-name" select="name(../*[@index = $index+1])"/>

        <!-- check if the next character is a round open-bracket, in which case we have a function -->
        <xsl:choose>
            <xsl:when test="$next-name = 'open-bracket'">
                <xsl:variable name="function-parameter-lists">
                    <xsl:apply-templates select="../*[@index = $index+1]" mode="expression-tokens-to-lists">

                    </xsl:apply-templates>
                </xsl:variable>
                <function index="{$index}" name="{.}">
                    <xsl:copy-of select="$function-parameter-lists"/>
                </function>
                <!-- continue on from the end of the lists -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="expression-tokens-to-lists-default">
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="open-bracket|open-square-bracket" mode="expression-tokens-to-lists" priority="2">
        <xsl:variable name="index" select="@index"/>

        <xsl:variable name="contents">
            <xsl:apply-templates select="../*[@index = $index + 1]" mode="expression-tokens-to-lists">
            </xsl:apply-templates>
        </xsl:variable>

        <list index="{$index}" type="{name()}">
            <xsl:copy-of select="$contents"/>
        </list>

        <xsl:variable name="contents-end" select="exslt:node-set($contents)/list-end"/>

        <xsl:if test="exslt:node-set($contents-end)/@type = 'comma'">
            <xsl:variable name="contents-end-index" select="exslt:node-set($contents-end)/@index"/>
            <!-- create another list -->
            <list index="{$contents-end-index}" type="comma">
                <xsl:apply-templates select="../*[@index = $contents-end-index + 1]" mode="expression-tokens-to-lists"/>
            </list>
        </xsl:if>

    </xsl:template>

    <xsl:template match="close-bracket|close-square-bracket|comma" mode="expression-tokens-to-lists" priority="2">
        <!-- do nothing, we exit the bracketing -->
        <list-end index="{@index}" type="{name()}"/>
    </xsl:template>

</xsl:stylesheet>