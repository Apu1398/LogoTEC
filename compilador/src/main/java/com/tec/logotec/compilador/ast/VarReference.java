package com.tec.logotec.compilador.ast;

public class VarReference implements ASTNode {

	private String name;
	

	
	public VarReference(String name) {
		super();
		this.name = name;
	}




	@Override
	public Object execute(Context symbolTable) {
		return symbolTable.get(name);		
	}

}
