package com.tec.logotec.compilador.ast;

public class VarInc implements ASTNode {

	private String name;
	private ASTNode mathExpression;
	
	
	
	public VarInc(String name, ASTNode mathExpression) {
		super();
		this.name = name;
		this.mathExpression = mathExpression;
	}
	
	
	@Override
	public Object execute(Context symbolTable) {
		int currentNumberValue  = (int)symbolTable.get(name);
		symbolTable.put(name, (int)mathExpression.execute(symbolTable)+currentNumberValue);	
		return null;
	}
	
	
	

}
