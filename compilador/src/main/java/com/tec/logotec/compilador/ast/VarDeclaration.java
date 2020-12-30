package com.tec.logotec.compilador.ast;

import java.util.Map;

public class VarDeclaration implements ASTNode {

	private String name; 
	
	
	public VarDeclaration(String name) {
		super();
		this.name = name;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		symbolTable.put(name, new Object());
		return null;
	}

}
