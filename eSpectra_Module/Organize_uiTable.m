function Organize_uiTable (uiTable_Object, Row_Name_Length)

jscroll             = findjobj(uiTable_Object);
rowHeaderViewport   = jscroll.getComponent(4);
rowHeader           = rowHeaderViewport.getComponent(0);
height              = rowHeader.getHeight;
rowHeaderViewport.setPreferredSize(java.awt.Dimension(Row_Name_Length,0));
rowHeader.setPreferredSize(java.awt.Dimension(Row_Name_Length,height));
rowHeader.setSize(Row_Name_Length,height);
rend                = rowHeader.getCellRenderer(2,0);
rend.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);