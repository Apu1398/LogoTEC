package com.tec.logotec.compilador.ast;

public class VarDeclaration implements ASTNode {

	private String name; 
	
	
	public VarDeclaration(String name) {
		super();
		this.name = name;
	}



	@Override
	public Object execute(Context symbolTable) {
		symbolTable.put(name, new Object());
		return null;
	}

}
