package com.tec.logotec.compilador.ast;

public class VarIncByNumb implements ASTNode {

	private String name;
	
	public VarIncByNumb(String name) {
		super();
		this.name = name;
	}
	

	@Override
	public Object execute(Context symbolTable) {
		int currentNumberValue  = (int)symbolTable.get(name);

		symbolTable.put(name, 1+currentNumberValue);
		
		return null;
	}

}
