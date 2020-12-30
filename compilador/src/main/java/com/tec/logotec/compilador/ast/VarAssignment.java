package com.tec.logotec.compilador.ast;

import java.util.Map;

public class VarAssignment implements ASTNode {

	private String name;
	private ASTNode expression;
	
	
	
	public VarAssignment(String name, ASTNode expression) {
		super();
		this.name = name;
		this.expression = expression;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		symbolTable.put(name, expression.execute(symbolTable));
		return null;
	}

}
