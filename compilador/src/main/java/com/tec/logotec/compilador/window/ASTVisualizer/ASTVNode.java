package com.tec.logotec.compilador.window.ASTVisualizer;

import java.util.ArrayList;
import java.util.List;

public class ASTVNode {
	
	public List<ASTVNode> childs = new ArrayList<ASTVNode>();
	public String value;
	
	
	public ASTVNode(String value) {
		this.value = value;
	}
	
	public void  addChild(ASTVNode node) {
		childs.add(node);
		
	}
	
	public int countChilds() {
		return childs.size();
	}
	

}
