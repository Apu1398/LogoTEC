package com.tec.logotec.compilador.ast;

public class VarInitialization implements ASTNode {
	private String name;
	private ASTNode expression;
	
	
	
	public VarInitialization(String name, ASTNode expression) {
		super();
		this.name = name;
		this.expression = expression;
	}



	@Override
	public Object execute(Context symbolTable) {
		symbolTable.put(name, expression.execute(symbolTable));
		return null;
	}

}
