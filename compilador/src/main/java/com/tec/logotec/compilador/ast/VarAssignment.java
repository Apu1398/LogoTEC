package com.tec.logotec.compilador.ast;

public class VarAssignment implements ASTNode {

	private String name;
	private ASTNode expression;
	
	
	
	public VarAssignment(String name, ASTNode expression) {
		super();
		this.name = name;
		this.expression = expression;
	}



	@Override
	public Object execute(Context symbolTable) {
		Object data = expression.execute(symbolTable);
		
		if(symbolTable.get(name).getClass().equals(data.getClass())) {

			symbolTable.put(name, data);
		}
		
		else {
			System.out.println("Error detected");
		}
		return null;
	}

}
