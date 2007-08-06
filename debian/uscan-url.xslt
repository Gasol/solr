<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>

<xsl:template match="dehs">
  <xsl:value-of select="upstream-url"/>
</xsl:template>

</xsl:stylesheet>

