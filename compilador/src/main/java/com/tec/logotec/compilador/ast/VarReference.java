package com.tec.logotec.compilador.ast;

import java.util.Map;

public class VarReference implements ASTNode {

	private String name;
	

	
	public VarReference(String name) {
		super();
		this.name = name;
	}




	@Override
	public Object execute(Map<String, Object> symbolTable) {
		return symbolTable.get(name);		
	}

}
