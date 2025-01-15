// Fill out your copyright notice in the Description page of Project Settings.


#include "BaseGardenManager.h"

// Sets default values
ABaseGardenManager::ABaseGardenManager()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

}

// Called when the game starts or when spawned
void ABaseGardenManager::BeginPlay()
{
	Super::BeginPlay();
	
}

// Called every frame
void ABaseGardenManager::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

